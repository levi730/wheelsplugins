<h1>BlankDefaults</h1>

<p>
	The BlankDefaults plugin overrides the <code>$setDefaultValues()</code> method in an attempt to include blank properties when defaulting Wheels model objects.
</p>


<h2>Overridden Methods</h2>
<ul>
	<li>$setDefaultValues()</li>
</ul>

<p>
	Rather than checking only for database fields that have specified default values, this method will now create blank placeholder properties for those fields without a default in the database.
</p>

<h2>How to Use</h2>

<p>
  Install it! Then the new method is automatically available to you.
</p>

<p>
  The primary target for this functionality is the model method <code>new()</code>.  You will probably see no changes in 
behavior unless you set the <code>defaults</code> parameter to the <code>new()</code> method.  This can be done for all calls to 
<code>new()</code> by adding the following to your settings file:
</p>

<p><code>&lt;cfset set(functionName="new", defaults=true)&gt;</code></p>

<p>
  See the <a href="http://cfwheels.org/docs/chapter/configuration-and-defaults">Configuration and Defaults</a> page of the 
Wheels documentation for more info.
</p>

<h2>Uninstallation</h2>

<p>All you need to do is delete the <tt>/plugins/BlankDefaults-x.x.zip</tt> file.</p>

<h2>Thanks</h2>



<h2>Release History</h2>

<ul>
	<li>2010-03-18 -- 0.1
		<ul>
			<li>plugin created</li>
		</ul>
	</li>
</ul>

<!--
<h2>Problems/Known Issues</h2>

<ul>
	<li>&nbsp;</li>
</ul>
-->

<h2>License</h2>

<p>(The MIT License)</p>

<p>Copyright (c) 2010 Mike Lester</p>

<p>Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:</p>

<p>The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.</p>

<p>THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>
