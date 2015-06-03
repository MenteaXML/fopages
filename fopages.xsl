<!-- ============================================================= -->
<!--  MODULE:     fopages.xsl                                      -->
<!--  VERSION:    1                                                -->
<!--  DATE:       12 August 2011                                   -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:      fopages                                          -->
<!--                                                               -->
<!-- PURPOSE:     Summarise the page masters in a FO document      -->
<!--                                                               -->
<!-- INPUT FILE:  XSL FO document                                  -->
<!--                                                               -->
<!-- OUTPUT FILE: Text (at least initially)                        -->
<!--                                                               -->
<!-- CREATED FOR: fun                                              -->
<!--                                                               -->
<!-- CREATED BY:  Mentea                                           -->
<!--              13 Kelly's Bay Beach                             -->
<!--              Skerries, Co. Dublin                             -->
<!--              Ireland                                          -->
<!--              http://www.mentea.net/                           -->
<!--              info@mente.net                                   -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--              12 August 2011                                   -->
<!--                                                               -->
<!-- CREATED BY:  Tony Graham (tkg)                                -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--              VERSION HISTORY                                  -->
<!-- ============================================================= -->
<!--
 1.  ORIGINAL VERSION                                 tkg 20110812
                                                                   -->

<!-- ============================================================= -->
<!--                    DESIGN CONSIDERATIONS                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    XSL STYLESHEET INVOCATION                  -->
<!-- ============================================================= -->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:m="http://www.mentea.net"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0"
    exclude-result-prefixes="xs fo">

<xsl:output
    method="xhtml" />

<!-- ============================================================= -->
<!--                    GLOBAL VARIABLES                           -->
<!-- ============================================================= -->

<xsl:variable
    name="colors"
    select="'light blue',
            'red',
	    'green',
	    'blue',
	    'yellow',
	    'magenta',
	    'cyan',
	    'gray',
	    'black',
	    'orange',
	    'dark green',
	    'teal',
	    'tan',
	    'brown',
	    'violet',
	    'gold',
	    'dark blue',
	    'pink',
	    'lavender',
	    'brick red',
	    'olive',
	    'peach',
	    'burgundy',
	    'grass green',
	    'ochre',
	    'purple',
	    'light gray'"
    as="xs:string+" />


<!-- ============================================================= -->
<!--                    STYLESHEET PARAMETERS                      -->
<!-- ============================================================= -->

<!-- Number of pixels per inch used by SVG. -->
<xsl:variable name="pixels-per-inch" select="96" as="xs:integer" />


<!-- ============================================================= -->
<!--                    TEMPLATE RULES                             -->
<!-- ============================================================= -->

<xsl:template match="fo:root">
  <html>
    <head>
      <title>FO Page Summary</title>
<style>
top.begin { stop-color:yellow; }
stop.end { stop-color:silver; }
body.invalid stop.end { stop-color:red; }
#err { display:none; }
body.invalid #err { display:inline; }
td.preview { padding: 6pt; }
</style>
<script src="mathmlAndSvgForHTML4.js"></script>   </head>
    <body>
<!--
<svg xmlns="http://www.w3.org/2000/svg" version="1.1"
viewBox="0 0 100 100" preserveAspectRatio="xMidYMid slice"
  style="width:100%; height:100%; position:absolute; top:0; left:0; z-index:-1;">
  <linearGradient id="gradient">
  <stop class="begin" offset="0%"/>
  <stop class="end" offset="100%"/>
  </linearGradient>
  <rect x="0" y="0" width="100" height="100" style="fill:url(#gradient)" />
  <circle cx="50" cy="50" r="30" style="fill:url(#gradient)" />
  </svg>
-->
      <xsl:apply-templates select="fo:layout-master-set"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="fo:layout-master-set">
  <xsl:if test="exists(fo:simple-page-master)">
    <div id="page-masters">
      <h1>Page Masters</h1>
      <ul>
        <xsl:apply-templates select="fo:simple-page-master">
          <xsl:sort select="@master-name" />
        </xsl:apply-templates>
      </ul>
    </div>
  </xsl:if>
  <xsl:if test="exists(fo:page-sequence-master)">
    <div id="page-sequence-masters">
      <h1>Page Sequence Masters</h1>
      <ul>
        <xsl:apply-templates select="fo:page-sequence-master">
          <xsl:sort select="@master-name" />
        </xsl:apply-templates>
      </ul>
    </div>
  </xsl:if>
  <xsl:if test="exists(fo:flow-map)">
    <div id="flow-maps">
      <h1>Flow Maps</h1>
      <ul>
        <xsl:apply-templates select="fo:flow-map">
          <xsl:sort select="@flow-map-name" />
        </xsl:apply-templates>
      </ul>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="fo:simple-page-master">
  <li id="spm_{@master-name}">
    <xsl:value-of select="@master-name" />
    <table border="1">
      <tr>
        <td>Width</td>
        <td>
          <xsl:value-of select="@page-width" />
        </td>
        <td rowspan="2" class="preview">
          <xsl:apply-templates select="." mode="preview" />
        </td>
      </tr>
      <tr>
        <td>Height</td>
        <td>
          <xsl:value-of select="@page-height" />
        </td>
      </tr>
    </table>
  </li>
</xsl:template>

<xsl:template match="fo:page-sequence-master">
  <li id="psm_{@master-name}">
    <xsl:value-of select="@master-name" />
    <xsl:apply-templates />
  </li>
</xsl:template>

<xsl:template match="fo:flow-map">
  <li id="fm_{@flow-map-name}">
    <xsl:value-of select="@flow-map-name" />
  </li>
</xsl:template>

<xsl:template match="fo:repeatable-page-master-alternatives">
  <table border="1">
    <tr>
      <th>Page master</th>
      <th>Blank?</th>
      <th>Odd or even?</th>
    </tr>
    <xsl:apply-templates />
  </table>
</xsl:template>

<xsl:template match="fo:conditional-page-master-reference">
  <tr>
    <td>
      <a href="#spm_{@master-reference}">
        <xsl:value-of select="@master-reference" />
      </a>
    </td>
    <td>
      <xsl:value-of select="@blank-or-not-blank" />
    </td>
    <td>
      <xsl:value-of select="@odd-or-even" />
    </td>
  </tr>
</xsl:template>

<!-- Drop the text. -->
<xsl:template match="text()" />


<!-- ============================================================= -->
<!-- FUNCTIONS                                                     -->
<!-- ============================================================= -->

<xsl:template match="fo:simple-page-master" mode="preview">
  <xsl:variable name="x" select="m:pt(@margin-left)" as="xs:double" />
  <xsl:variable name="y" select="m:pt(@margin-top)" as="xs:double" />
  <xsl:variable name="width"
                select="m:pt(@page-width) - m:pt((@margin-left, @margin-right))"
                as="xs:double" />
  <xsl:variable name="height"
                select="m:pt(@page-height) - m:pt((@margin-top, @margin-bottom))"
                as="xs:double" />

  <svg xmlns="http://www.w3.org/2000/svg" version="1.1"
       viewBox="0 0 {m:pixels(@page-width)} {m:pixels(@page-height)}"
       preserveAspectRatio="xMinYMin"
       style="width:100px; height:100px; z-index:-1;">
    <rect x="0" y="0" width="{@page-width}" height="{@page-height}"
          fill="none" stroke="blue" />
    <rect x="{$x}pt" y="{$y}pt"
          width="{$width}pt"
          height="{$height}pt"
          fill="none" stroke="red"/>
    <xsl:apply-templates mode="#current">
      <xsl:with-param name="x" select="$x" as="xs:double" />
      <xsl:with-param name="y" select="$y" as="xs:double" />
      <xsl:with-param name="width" select="$width" as="xs:double" />
      <xsl:with-param name="height" select="$height" as="xs:double" />
    </xsl:apply-templates>
  </svg>
</xsl:template>

<xsl:template match="fo:region-body" mode="preview">
  <xsl:param name="x" as="xs:double" />
  <xsl:param name="y" as="xs:double" />
  <xsl:param name="width" as="xs:double" />
  <xsl:param name="height" as="xs:double" />

  <rect xmlns="http://www.w3.org/2000/svg"
        x="{$x + m:pt(@margin-left)}pt" y="{$y + m:pt(@margin-top)}pt"
        width="{$width - m:pt((@margin-left, @margin-right))}pt"
        height="{$height - m:pt((@margin-top, @margin-bottom))}pt"
        fill="none" stroke="green" />
</xsl:template>


<!-- ============================================================= -->
<!-- FUNCTIONS                                                     -->
<!-- ============================================================= -->

<xsl:variable name="units" as="element(m:unit)+">
  <m:unit name="in" per-inch="1" />
  <m:unit name="pt" per-inch="72" />
  <m:unit name="pc" per-inch="6" />
  <m:unit name="cm" per-inch="2.54" />
  <m:unit name="mm" per-inch="25.4" />
  <m:unit name="px" per-inch="{$pixels-per-inch}" />
</xsl:variable>

<xsl:variable
    name="units-pattern"
    select="concat('(',
                   string-join($units/@name, '|'),
                   ')')"
    as="xs:string" />

<xsl:function name="m:pixels" as="xs:integer">
  <xsl:param name="length" as="xs:string" />

  <xsl:variable
      name="length"
      select="normalize-space($length)"/>

  <xsl:choose>
    <xsl:when test="ends-with($length, 'in')">
      <xsl:sequence
          select="xs:integer(number(substring-before($length, 'in')) * $pixels-per-inch)" />
    </xsl:when>
    <xsl:when test="ends-with($length, 'mm')">
      <xsl:sequence
          select="xs:integer(number(substring-before($length, 'mm')) * 25.4 * $pixels-per-inch)" />
    </xsl:when>
    <xsl:when test="ends-with($length, 'pc')">
      <xsl:sequence
          select="xs:integer((number(substring-before($length, 'pc')) div 6) * $pixels-per-inch)" />
    </xsl:when>
    <xsl:when test="ends-with($length, 'pt')">
      <xsl:sequence
          select="xs:integer((number(substring-before($length, 'pc')) div 72) * $pixels-per-inch)" />
    </xsl:when>
    <xsl:when test="ends-with($length, 'px')">
      <xsl:sequence
          select="xs:integer(substring-before($length, 'px'))" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="10" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="m:pt" as="xs:double">
  <xsl:param name="lengths" as="xs:string*" />

  <xsl:sequence select="sum(for $length in $lengths
                              return m:length-to-pt($length))" />
</xsl:function>

<xsl:function name="m:length-to-pt" as="xs:double">
  <xsl:param name="length" as="xs:string" />

  <xsl:choose>
    <xsl:when test="matches($length, concat('^-?\d+(\.\d*)?', $units-pattern, '$'))">
      <!--<xsl:message select="$length" />-->
      <xsl:analyze-string
          select="$length"
          regex="{concat('^(-?\d+(\.\d*)?)', $units-pattern, '$')}">
        <xsl:matching-substring>
          <xsl:sequence
              select="xs:double(regex-group(1)) * $units[@name eq 'pt']/@per-inch div
                      xs:double($units[@name eq regex-group(3)]/@per-inch)" />
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message select="concat('Unrecognized length: ', $length)" />
      <xsl:sequence select="0" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>

<!-- ============================================================= -->
<!--                    End of fopages.xsl                         -->
<!-- ============================================================= -->
