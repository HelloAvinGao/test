// <!DOCTYPE html>
// <html>
// <head>
// <meta charset="utf-8">
// <script type="text/javascript">
// // function ajax(url, method, msg, fn) {
// //     var xmlhttp;
// //     if(window.XMLHttpRequest){
// //         xmlhttp=new XMLHttpRequest();
// //     }else {
// //         xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
// //     }
// //     xmlhttp.onreadystatechange=function(){
// //         if(xmlhttp.readyState==4 && xmlhttp.status==200){
// //             fn(xmlhttp.responseText, url)
// //         }
// //     }
// //     xmlhttp.open(method,url,true);
// //     xmlhttp.send(msg);
// // }
// // window.setInterval(ajax("sandbox/", "GET", "", listJob), 1000);
//
// function ajaxDEL(){
//   var xmlhttp;
//   if(window.XMLHttpRequest){
//     xmlhttp=new XMLHttpRequest();
//   }else {
//     xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
//   }
//   xmlhttp.onreadystatechange=function(){
//     if(xmlhttp.readyState==4&&xmlhttp.status==200){
//       var data=xmlhttp.responseText;
//       console.log(data);
//     }
//   }
//   xmlhttp.open("DELETE","State.JSON",true);
//   xmlhttp.send();
// }
//
// function ajaxPUT(){
//   var xmlhttp;
//   var obj={
//     "a":"hello a",
//     "b":"hello b"
//   }
//   if(window.XMLHttpRequest){
//     xmlhttp=new XMLHttpRequest();
//   }else {
//     xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
//   }
//   xmlhttp.onreadystatechange=function(){
//     if(xmlhttp.readyState==4&&xmlhttp.status==200){
//       var data=xmlhttp.responseText;
//       console.log(data);
//     }
//   }
//   xmlhttp.open("PUT","State.JSON",true);
//   xmlhttp.send(JSON.stringify(obj));
// }
//
//
// function loadXMLDoc()
// {
//  var xmlhttp;
//  if (window.XMLHttpRequest)
//  {
//    //  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
//    xmlhttp=new XMLHttpRequest();
//  }
//  else
//  {
//    // IE6, IE5 浏览器执行代码
//    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
//  }
//  xmlhttp.onreadystatechange=function()
//  {
//    if (xmlhttp.readyState==4 && xmlhttp.status==200)
//    {
//      var dataobj = JSON.parse(xmlhttp.responseText);
//      document.getElementById("myDiv").innerHTML= xmlhttp.responseText;
//    }
//  }
//
//  xmlhttp.open("GET","test.json",true);
//  // xmlhttp.setRequestHeader("x-api-key","");
//  xmlhttp.send();
// }
// </script>
// </head>
// <body onload="loadXMLDoc()">
// <div id="myDiv"></div>
// <button onclick="ajaxPUT()">PUT</button>
// <button onclick="ajaxDEL()">DEL</button>
// </body>
// </html>
