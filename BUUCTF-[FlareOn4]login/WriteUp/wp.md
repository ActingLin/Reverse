


```javascript
document.getElementById("prompt").onclick = function () {
    var flag = document.getElementById("flag").value;
    var rotFlag = flag.replace(/[a-zA-Z]/g, function(c){return String.fromCharCode((c <= "Z" ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26);});
    if ("PyvragFvqrYbtvafNerRnfl@syner-ba.pbz" == rotFlag) {
        alert("Correct flag!");
    } else {
        alert("Incorrect flag, rot again");
    }
}      
```
rot13解密
![alt text](image.png)