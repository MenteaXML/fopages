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
    <svg xmlns="http://www.w3.org/2000/svg" version="1.1"
         viewBox="0 0 {m:pixels(@page-width)} {m:pixels(@page-height)}" preserveAspectRatio="xMinYMin"
         style="width:100px; height:100px; z-index:-1;">
      <rect x="0" y="0" width="{@page-width}" height="{@page-height}" fill="none" stroke="blue" />
    </svg>
  </li>
</xsl:template>

<xsl:template match="fo:page-sequence-master">
  <li id="psm_{@master-name}">
    <xsl:value-of select="@master-name" />
  </li>
</xsl:template>

<xsl:template match="fo:flow-map">
  <li id="fm_{@flow-map-name}">
    <xsl:value-of select="@flow-map-name" />
  </li>
</xsl:template>

<!-- Drop the text. -->
<xsl:template match="text()" />


<!-- ============================================================= -->
<!--                    FUNCTIONS                                  -->
<!-- ============================================================= -->

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

</xsl:stylesheet>

<!-- ============================================================= -->
<!--                    End of fopages.xsl                         -->
<!-- ============================================================= -->
