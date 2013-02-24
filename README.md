<h1>RepRap Cloud</h1>

<b>Version: 0.009 (ALPHA)</b>

RepRapCloud (rrcloud) is a small but powerful perl-script which provides an easy framework to relay computational work remote among many servers and retrieve the results locally; both synchronous (returns when done) and asynchronous (return immediately telling you the state of task 'busy', 'complete' or 'failed').

<pre>
% slic3r.cloud huge.stl --output=huge.gcode
</pre>

which uses <tt>myserver.local</tt> and starts there the slicing task for <tt>huge.stl</tt> there, and returns when the task is done (synchronous).

<pre>
% rrcloud --s=myserver.local slic3r huge.stl
</pre>

does the same, except the results are not yet exported but reside in <tt>tasks/in/*</tt>

<h2>Requirements</h2>

<ul>
<li>perl
<li>curl
<li>Apache HTTPD or Lighttpd
<li>multiple machines
</ul>

<h2>What Works</h2>
<img src="doc/workflow.png">

<ul>
<li><b>openscad</b> (single input/ouput)
<li><b>slic3r</b>
<li>not yet but planned:
<ul>
<li>print3d
<li>multi-stage openscad -> slic3r -> print3d
</ul>
</ul>


<h2>History</h2>
<ul>
<li> 2013/02/24: 0.009: replaced `` by fork & exec combo, a bit code cleaning up 
<li> 2013/02/24: 0.008: additional prearguments (e.g. --load=file.conf as for slic3r)
<li> 2013/02/23: 0.007: directory support as input (experimental, disabled)
<li> 2013/02/22: 0.005: multiple input files supported, added 'echo' service
<li> 2013/02/19: 0.002: remote stuff slowly working, not yet complete
<li> 2013/02/18: 0.001: first version, simple services of openscad, slic3r working
</ul>

<h2>Install</h2>

<pre>
% make install
</pre>

<h3>Permissions</h3>

Be aware that <tt>rrcloud</tt> is a command-line program (CLI) and a CGI in one, the CLI is execute under your login, whereas the CGI is executed as user www-data or so (depends on your UNIX).
<tt>rrcloud</tt> (and <tt>*.cloud</tt>) create
<ul>
<li>tasks/
<ul>
<li>in/
<li>out/
<li>log/
<li>info/
</ul>
</ul>
under that identity, after than if you mix CLI and CGI it may cause premission problems, e.g. www-data not having the permission to write files under directories created under your user identity.

<b>Solution</b>

1) Uniform Use: Do not mix CLI and CGI, e.g. use <tt>rrcloud</tt> and <tt>*.cloud</tt> as CLI on a local machine, and on a sever only used it to receive requests but not operated via CLI.

2) Mixed Use: make user <tt>www-data</tt> part of your group (/etc/group), so user <tt>www-data</tt> can write into directories created by you (your login) - this way you can use the mixed operation.

<b>Note:</b> do not use <tt>rrcloud</tt> on itself, e.g. call <tt>rrcloud --s=localhost info</tt> and which calls the same local <tt>rrcloud</tt>.

<h2>Usage: Command Line</h2>

<tt>rrcloud</tt> is a hybrid of CLI and CGI as mentioned, so it can be used on the command-line or web, as client or server:

<h3>Local</h3>

<pre>
% ./openscad.cloud tests/cube.scad -otests/cube.stl
% ./slicer.cloud tests/cube.stl --output=tests/cube.gcode
</pre>

Note: <tt>*.cloud</tt> is just symbolical links (sym-links) to <tt>rrcloud</tt>, depending on the name <tt>rrcloudM/tt> behaves accordingly.

<h3>Remote</h3>

Edit <tt>rrcloudrc</tt> in the same directory (or <tt>~/.rrcloudrc</tt>):
<pre>
servers = server.local,server2.local      # , separated list
slic3r.servers = server.local             # server(s) for slic3r.cloud only
</pre>

then
<pre>
% ./openscad.cloud tests/cube.scad -otests/cube.stl
% ./slicer.cloud tests/cube.stl --output=tests/cube.gcode
</pre>

<h2>Usage: Web</h2>

<tt>index.cgi</tt> is just a sym-link to <tt>rrcloud</tt>, you can access the servers remotely via <tt>http://server.local:4468</tt> when you configured your Apache HTTPD or Lighttpd accordingly (document root to <tt>RepRapCloud/</tt>).

<h3>Apache</h3>

<h3>Lighttpd</h3>
Add to your <tt>/etc/lighttpd/lighttpd.conf</tt> something like this:
<pre>
$SERVER["socket"] == ":4468" {
   server.document-root = "/your-path-to-files/RepRapCloud/"
   server.reject-expect-100-with-417 = "disable"
   index-file.names = ( "index.cgi" )
   cgi.assign = ( ".cgi" => "/usr/bin/perl" )
}
</pre>
The <tt>server.reject-expect-100-with-417 = "disable"</tt> are required for <tt>curl</tt> to work.
            
<h3>Web Access</h3>

Depending of the program (HTTP_USER_AGENT) <tt>rrcloud</tt> formats the output accordingly, e.g. a web-browser gets a nice formatted list, whereas wget/curl or so gets a simple text list.
You can also force that it returns JSON, e.g. 
<ul>
<li><tt>http://server.local/?service=info&format=json</tt> list all tasks (complete, failed or busy)
<li><tt>http://server.local/?service=info&id=<i>id</id></tt> to list info about a particular task
</ul>

Since the main transportation layer is HTTP, you can use existing load-balancing software to distribute the tasks within one single IP.

<b>Note: This is <u>ALPHA</u> software, no thorough security code-review has happened yet, so use it solely in a trusted (local) network.</b>


