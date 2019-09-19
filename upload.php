<!DOCTYPE html >
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>上传图片文件</title>
</head>
<?php
if (isset($_FILES['imgfile'])
&& is_uploaded_file($_FILES['imgfile']['tmp_name']))
{
 $imgFile = $_FILES['imgfile'];
$upErr = $imgFile['error'];
if ($upErr == 0)
{
$imgType = $imgFile['type']; //文件类型。
/* 判断文件类型，这个例子里仅支持jpg和gif类型的图片文件。*/
if ($imgType == 'image/jpeg'
|| $imgType == 'image/gif')
{
$imgFileName = $imgFile['name'];
$imgSize = $imgFile['size'];
$imgTmpFile = $imgFile['tmp_name'];
/* 将文件从临时文件夹移到上传文件夹中。*/
move_uploaded_file($imgTmpFile, 'upfile/'.$imgFileName);
/*显示上传后的文件的信息。*/
$strPrompt = sprintf("文件%s上传成功<br>"
. "文件大小: %s字节<br>"
. "<img src='upfile/%s'>"
, $imgFileName, $imgSize, $imgFileName
);
echo $strPrompt;
}
else
{
echo "请选择jpg或gif文件，不支持其它类型的文件。";
}
}
else
{
echo "文件上传失败。<br>";
switch ($upErr)
{
case 1:
 echo "超过了php.ini中设置的上传文件大小。";
break;
case 2:
 echo "超过了MAX_FILE_SIZE选项指定的文件大小。";
break;
case 3:
 echo "文件只有部分被上传。";
break;
case 4:
 echo "文件未被上传。";
break;
case 5:
 echo "上传文件大小为0";
break;
}
}
}
else
{
/*显示表单。*/
?>
<body>
<form action="" method="post" enctype="multipart/form-data" name="upload_form">
 <label>选择图片文件</label>
 <input name="imgfile" type="file" accept="image/gif, image/jpeg"/>
  <input name="upload" type="submit" value="上传" />
</form>
</body>
<?php
}
?>
</html>
