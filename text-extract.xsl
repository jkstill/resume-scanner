<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:output method="text"/>

   <xsl:template match="catalog">
      <xsl:call-template name="header" />
      <xsl:apply-templates select="book" />
   </xsl:template>

   <xsl:template name="header">
      <xsl:for-each select="//book[1]/child::*" >
         <xsl:value-of select="name()" />
         <xsl:if test="following-sibling::*">|</xsl:if>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
   </xsl:template>

   <xsl:template match="book">
      <xsl:for-each select="child::*" >
         <xsl:value-of select="." />
         <xsl:if test="following-sibling::*">|</xsl:if>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
   </xsl:template>

</xsl:stylesheet>
