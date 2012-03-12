import module namespace fop = "http://www.zorba-xquery.com/modules/xsl-fo";
import module namespace file = "http://expath.org/ns/file";

declare namespace fo = "http://www.w3.org/1999/XSL/Format";

let $xsl-fo := <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <fo:layout-master-set>
    <fo:simple-page-master master-name="my-page">
      <fo:region-body margin="1in"/>
    </fo:simple-page-master>
  </fo:layout-master-set>

  <fo:page-sequence master-reference="my-page">
    <fo:flow flow-name="xsl-region-body">
      <fo:block>Hello, world!</fo:block>
    </fo:flow>
  </fo:page-sequence>
 </fo:root>
let $pdfBase64Binary := fop:generator($fop:PDF, $xsl-fo)
let $pdf := xs:string($pdfBase64Binary)
let $len := fn:string-length($pdf)
return 
  <pdf>
    <len>  { $len }</len>
    <start>{ fn:substring($pdf, 1, 10)}</start>
    <end>  { fn:substring($pdf, $len -10, $len)}</end>
  </pdf>
