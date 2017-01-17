!function(e){var n="object"==typeof window&&window||"object"==typeof self&&self
"undefined"!=typeof exports?e(exports):n&&(n.hljs=e({}),"function"==typeof define&&define.amd&&define([],function(){return n.hljs}))}(function(e){function n(e){return e.replace(/[&<>]/gm,function(e){return j[e]})}function t(e){return e.nodeName.toLowerCase()}function r(e,n){var t=e&&e.exec(n)
return t&&0===t.index}function a(e){return k.test(e)}function i(e){var n,t,r,i,c=e.className+" "
if(c+=e.parentNode?e.parentNode.className:"",t=C.exec(c))return x(t[1])?t[1]:"no-highlight"
for(c=c.split(/\s+/),n=0,r=c.length;r>n;n++)if(i=c[n],a(i)||x(i))return i}function c(e,n){var t,r={}
for(t in e)r[t]=e[t]
if(n)for(t in n)r[t]=n[t]
return r}function s(e){var n=[]
return function r(e,a){for(var i=e.firstChild;i;i=i.nextSibling)3===i.nodeType?a+=i.nodeValue.length:1===i.nodeType&&(n.push({event:"start",offset:a,node:i}),a=r(i,a),t(i).match(/br|hr|img|input/)||n.push({event:"stop",offset:a,node:i}))
return a}(e,0),n}function o(e,r,a){function i(){return e.length&&r.length?e[0].offset!==r[0].offset?e[0].offset<r[0].offset?e:r:"start"===r[0].event?e:r:e.length?e:r}function c(e){function r(e){return" "+e.nodeName+'="'+n(e.value)+'"'}l+="<"+t(e)+E.map.call(e.attributes,r).join("")+">"}function s(e){l+="</"+t(e)+">"}function o(e){("start"===e.event?c:s)(e.node)}for(var u=0,l="",f=[];e.length||r.length;){var g=i()
if(l+=n(a.substring(u,g[0].offset)),u=g[0].offset,g===e){f.reverse().forEach(s)
do o(g.splice(0,1)[0]),g=i()
while(g===e&&g.length&&g[0].offset===u)
f.reverse().forEach(c)}else"start"===g[0].event?f.push(g[0].node):f.pop(),o(g.splice(0,1)[0])}return l+n(a.substr(u))}function u(e){function n(e){return e&&e.source||e}function t(t,r){return RegExp(n(t),"m"+(e.cI?"i":"")+(r?"g":""))}function r(a,i){if(!a.compiled){if(a.compiled=!0,a.k=a.k||a.bK,a.k){var s={},o=function(n,t){e.cI&&(t=t.toLowerCase()),t.split(" ").forEach(function(e){var t=e.split("|")
s[t[0]]=[n,t[1]?+t[1]:1]})}
"string"==typeof a.k?o("keyword",a.k):R(a.k).forEach(function(e){o(e,a.k[e])}),a.k=s}a.lR=t(a.l||/\w+/,!0),i&&(a.bK&&(a.b="\\b("+a.bK.split(" ").join("|")+")\\b"),a.b||(a.b=/\B|\b/),a.bR=t(a.b),a.e||a.eW||(a.e=/\B|\b/),a.e&&(a.eR=t(a.e)),a.tE=n(a.e)||"",a.eW&&i.tE&&(a.tE+=(a.e?"|":"")+i.tE)),a.i&&(a.iR=t(a.i)),null==a.r&&(a.r=1),a.c||(a.c=[])
var u=[]
a.c.forEach(function(e){e.v?e.v.forEach(function(n){u.push(c(e,n))}):u.push("self"===e?a:e)}),a.c=u,a.c.forEach(function(e){r(e,a)}),a.starts&&r(a.starts,i)
var l=a.c.map(function(e){return e.bK?"\\.?("+e.b+")\\.?":e.b}).concat([a.tE,a.i]).map(n).filter(Boolean)
a.t=l.length?t(l.join("|"),!0):{exec:function(){return null}}}}r(e)}function l(e,t,a,i){function c(e,n){var t,a
for(t=0,a=n.c.length;a>t;t++)if(r(n.c[t].bR,e))return n.c[t]}function s(e,n){if(r(e.eR,n)){for(;e.endsParent&&e.parent;)e=e.parent
return e}return e.eW?s(e.parent,n):void 0}function o(e,n){return!a&&r(n.iR,e)}function g(e,n){var t=N.cI?n[0].toLowerCase():n[0]
return e.k.hasOwnProperty(t)&&e.k[t]}function b(e,n,t,r){var a=r?"":y.classPrefix,i='<span class="'+a,c=t?"":B
return i+=e+'">',i+n+c}function p(){var e,t,r,a
if(!R.k)return n(C)
for(a="",t=0,R.lR.lastIndex=0,r=R.lR.exec(C);r;)a+=n(C.substring(t,r.index)),e=g(R,r),e?(M+=e[1],a+=b(e[0],n(r[0]))):a+=n(r[0]),t=R.lR.lastIndex,r=R.lR.exec(C)
return a+n(C.substr(t))}function h(){var e="string"==typeof R.sL
if(e&&!w[R.sL])return n(C)
var t=e?l(R.sL,C,!0,L[R.sL]):f(C,R.sL.length?R.sL:void 0)
return R.r>0&&(M+=t.r),e&&(L[R.sL]=t.top),b(t.language,t.value,!1,!0)}function d(){k+=null!=R.sL?h():p(),C=""}function v(e){k+=e.cN?b(e.cN,"",!0):"",R=Object.create(e,{parent:{value:R}})}function m(e,n){if(C+=e,null==n)return d(),0
var t=c(n,R)
if(t)return t.skip?C+=n:(t.eB&&(C+=n),d(),t.rB||t.eB||(C=n)),v(t,n),t.rB?0:n.length
var r=s(R,n)
if(r){var a=R
a.skip?C+=n:(a.rE||a.eE||(C+=n),d(),a.eE&&(C=n))
do R.cN&&(k+=B),R.skip||(M+=R.r),R=R.parent
while(R!==r.parent)
return r.starts&&v(r.starts,""),a.rE?0:n.length}if(o(n,R))throw Error('Illegal lexeme "'+n+'" for mode "'+(R.cN||"<unnamed>")+'"')
return C+=n,n.length||1}var N=x(e)
if(!N)throw Error('Unknown language: "'+e+'"')
u(N)
var E,R=i||N,L={},k=""
for(E=R;E!==N;E=E.parent)E.cN&&(k=b(E.cN,"",!0)+k)
var C="",M=0
try{for(var j,I,S=0;R.t.lastIndex=S,j=R.t.exec(t),j;)I=m(t.substring(S,j.index),j[0]),S=j.index+I
for(m(t.substr(S)),E=R;E.parent;E=E.parent)E.cN&&(k+=B)
return{r:M,value:k,language:e,top:R}}catch(T){if(T.message&&-1!==T.message.indexOf("Illegal"))return{r:0,value:n(t)}
throw T}}function f(e,t){t=t||y.languages||R(w)
var r={r:0,value:n(e)},a=r
return t.filter(x).forEach(function(n){var t=l(n,e,!1)
t.language=n,t.r>a.r&&(a=t),t.r>r.r&&(a=r,r=t)}),a.language&&(r.second_best=a),r}function g(e){return y.tabReplace||y.useBR?e.replace(M,function(e,n){return y.useBR&&"\n"===e?"<br>":y.tabReplace?n.replace(/\t/g,y.tabReplace):void 0}):e}function b(e,n,t){var r=n?L[n]:t,a=[e.trim()]
return e.match(/\bhljs\b/)||a.push("hljs"),-1===e.indexOf(r)&&a.push(r),a.join(" ").trim()}function p(e){var n,t,r,c,u,p=i(e)
a(p)||(y.useBR?(n=document.createElementNS("http://www.w3.org/1999/xhtml","div"),n.innerHTML=e.innerHTML.replace(/\n/g,"").replace(/<br[ \/]*>/g,"\n")):n=e,u=n.textContent,r=p?l(p,u,!0):f(u),t=s(n),t.length&&(c=document.createElementNS("http://www.w3.org/1999/xhtml","div"),c.innerHTML=r.value,r.value=o(t,s(c),u)),r.value=g(r.value),e.innerHTML=r.value,e.className=b(e.className,p,r.language),e.result={language:r.language,re:r.r},r.second_best&&(e.second_best={language:r.second_best.language,re:r.second_best.r}))}function h(e){y=c(y,e)}function d(){if(!d.called){d.called=!0
var e=document.querySelectorAll("pre code")
E.forEach.call(e,p)}}function v(){addEventListener("DOMContentLoaded",d,!1),addEventListener("load",d,!1)}function m(n,t){var r=w[n]=t(e)
r.aliases&&r.aliases.forEach(function(e){L[e]=n})}function N(){return R(w)}function x(e){return e=(e||"").toLowerCase(),w[e]||w[L[e]]}var E=[],R=Object.keys,w={},L={},k=/^(no-?highlight|plain|text)$/i,C=/\blang(?:uage)?-([\w-]+)\b/i,M=/((^(<[^>]+>|\t|)+|(?:\n)))/gm,B="</span>",y={classPrefix:"hljs-",tabReplace:null,useBR:!1,languages:void 0},j={"&":"&amp;","<":"&lt;",">":"&gt;"}
return e.highlight=l,e.highlightAuto=f,e.fixMarkup=g,e.highlightBlock=p,e.configure=h,e.initHighlighting=d,e.initHighlightingOnLoad=v,e.registerLanguage=m,e.listLanguages=N,e.getLanguage=x,e.inherit=c,e.IR="[a-zA-Z]\\w*",e.UIR="[a-zA-Z_]\\w*",e.NR="\\b\\d+(\\.\\d+)?",e.CNR="(-?)(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)",e.BNR="\\b(0b[01]+)",e.RSR="!|!=|!==|%|%=|&|&&|&=|\\*|\\*=|\\+|\\+=|,|-|-=|/=|/|:|;|<<|<<=|<=|<|===|==|=|>>>=|>>=|>=|>>>|>>|>|\\?|\\[|\\{|\\(|\\^|\\^=|\\||\\|=|\\|\\||~",e.BE={b:"\\\\[\\s\\S]",r:0},e.ASM={cN:"string",b:"'",e:"'",i:"\\n",c:[e.BE]},e.QSM={cN:"string",b:'"',e:'"',i:"\\n",c:[e.BE]},e.PWM={b:/\b(a|an|the|are|I'm|isn't|don't|doesn't|won't|but|just|should|pretty|simply|enough|gonna|going|wtf|so|such|will|you|your|like)\b/},e.C=function(n,t,r){var a=e.inherit({cN:"comment",b:n,e:t,c:[]},r||{})
return a.c.push(e.PWM),a.c.push({cN:"doctag",b:"(?:TODO|FIXME|NOTE|BUG|XXX):",r:0}),a},e.CLCM=e.C("//","$"),e.CBCM=e.C("/\\*","\\*/"),e.HCM=e.C("#","$"),e.NM={cN:"number",b:e.NR,r:0},e.CNM={cN:"number",b:e.CNR,r:0},e.BNM={cN:"number",b:e.BNR,r:0},e.CSSNM={cN:"number",b:e.NR+"(%|em|ex|ch|rem|vw|vh|vmin|vmax|cm|mm|in|pt|pc|px|deg|grad|rad|turn|s|ms|Hz|kHz|dpi|dpcm|dppx)?",r:0},e.RM={cN:"regexp",b:/\//,e:/\/[gimuy]*/,i:/\n/,c:[e.BE,{b:/\[/,e:/\]/,r:0,c:[e.BE]}]},e.TM={cN:"title",b:e.IR,r:0},e.UTM={cN:"title",b:e.UIR,r:0},e.METHOD_GUARD={b:"\\.\\s*"+e.UIR,r:0},e.registerLanguage("json",function(e){var n={literal:"true false null"},t=[e.QSM,e.CNM],r={e:",",eW:!0,eE:!0,c:t,k:n},a={b:"{",e:"}",c:[{cN:"attr",b:/"/,e:/"/,c:[e.BE],i:"\\n"},e.inherit(r,{b:/:/})],i:"\\S"},i={b:"\\[",e:"\\]",c:[e.inherit(r)],i:"\\S"}
return t.splice(t.length,0,a,i),{c:t,k:n,i:"\\S"}}),e.registerLanguage("xml",function(e){var n="[A-Za-z0-9\\._:-]+",t={eW:!0,i:/</,r:0,c:[{cN:"attr",b:n,r:0},{b:/=\s*/,r:0,c:[{cN:"string",endsParent:!0,v:[{b:/"/,e:/"/},{b:/'/,e:/'/},{b:/[^\s"'=<>`]+/}]}]}]}
return{aliases:["html","xhtml","rss","atom","xjb","xsd","xsl","plist"],cI:!0,c:[{cN:"meta",b:"<!DOCTYPE",e:">",r:10,c:[{b:"\\[",e:"\\]"}]},e.C("<!--","-->",{r:10}),{b:"<\\!\\[CDATA\\[",e:"\\]\\]>",r:10},{b:/<\?(php)?/,e:/\?>/,sL:"php",c:[{b:"/\\*",e:"\\*/",skip:!0}]},{cN:"tag",b:"<style(?=\\s|>|$)",e:">",k:{name:"style"},c:[t],starts:{e:"</style>",rE:!0,sL:["css","xml"]}},{cN:"tag",b:"<script(?=\\s|>|$)",e:">",k:{name:"script"},c:[t],starts:{e:"</script>",rE:!0,sL:["actionscript","javascript","handlebars","xml"]}},{cN:"meta",v:[{b:/<\?xml/,e:/\?>/,r:10},{b:/<\?\w+/,e:/\?>/}]},{cN:"tag",b:"</?",e:"/?>",c:[{cN:"name",b:/[^\/><\s]+/,r:0},t]}]}}),e})