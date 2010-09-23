<h1>DevMail</h1>

<p>
	The DevMail plugin overrides the "to" attribute of calls to the <code>$mail()</code> method for non-production environments.  
	It also modifies the body of the email message to include who the intended recipients were.  Most useful in the design/development environment where you 
	can continue to let your app send emails as normal, without the risk if inappropriate "test" emails going to live users or clients. 
</p>


<h2>Overridden Methods</h2>
<ul>
	<li>$mail()</li>
</ul>

<p>
	The method check for a  <code>emailOverride</code> setting.  If it exists, calls to <code>$mail()</code>
	will have their to, cc, and bcc arguments removed and placed in a note at the end of the message body.  The value of the <code>emailOverride</code> setting will then be used as the to argument.  If it does not exist, <code>$mail()</code> works as regular.
</p>

<h2>How to Use</h2>

<p>Install it! Then the new method is automatically available to you.</p>

<h2>Uninstallation</h2>

<p>All you need to do is delete the <tt>/plugins/DevMail-x.x.zip</tt> file.</p>

<h2>Thanks</h2>



<h2>Release History</h2>

<ul>
	<li>2010-09-23 -- 0.2
		<ul>
			<li>changed to be compatible with Wheels 1.1</li>
		</ul>
	</li>
	<li>2010-05-21 -- 0.1
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