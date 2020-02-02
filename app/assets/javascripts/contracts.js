var canvas = document.getElementById('canvassample'),
    ctx = canvas.getContext('2d'),
    moveflg = 0,
    Xpoint,
    Ypoint;

//初期値（サイズ、色、アルファ値）の決定
var defSize = 1,
    defColor = "#555";

// ストレージの初期化
var myStorage = localStorage;
window.onload = initLocalStorage();

// PC対応
canvas.addEventListener('mousedown', startPoint, false);
canvas.addEventListener('mousemove', movePoint, false);
canvas.addEventListener('mouseup', endPoint, false);
// スマホ対応
canvas.addEventListener('touchstart', startPoint, false);
canvas.addEventListener('touchmove', movePoint, false);
canvas.addEventListener('touchend', endPoint, false);

function startPoint(e){
  e.preventDefault();
  ctx.beginPath();

  Xpoint = e.layerX;
  Ypoint = e.layerY;

  ctx.moveTo(Xpoint, Ypoint);
}

function movePoint(e){
  if(e.buttons === 1 || e.witch === 1 || e.type == 'touchmove')
  {
    Xpoint = e.layerX;
    Ypoint = e.layerY;
    moveflg = 1;

    ctx.lineTo(Xpoint, Ypoint);
    ctx.lineCap = "round";
    ctx.lineWidth = defSize * 2;
    ctx.strokeStyle = defColor;
    ctx.stroke();

  }
}

function endPoint(e)
{

    if(moveflg === 0)
    {
      ctx.lineTo(Xpoint-1, Ypoint-1);
      ctx.lineCap = "round";
       ctx.lineWidth = defSize * 2;
      ctx.strokeStyle = defColor;
      ctx.stroke();
        
    }
    moveflg = 0;
  setLocalStoreage();
}

function clearCanvas(){
    if(confirm('Canvasを初期化しますか？'))
    {
        initLocalStorage();
        temp = [];
        resetCanvas();
    }
}

function resetCanvas() {
    ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);
}

function chgImg()
{
  var png = canvas.toDataURL();

  document.getElementById("newImg").src = png;

  // 出力された画像のURLをパラメーターに持たせる
  document.getElementById("param_sign").value = png;
}

function initLocalStorage(){
    myStorage.setItem("__log", JSON.stringify([]));
}
function setLocalStoreage(){
    var png = canvas.toDataURL();
    var logs = JSON.parse(myStorage.getItem("__log"));

    setTimeout(function(){
        logs.unshift({0:png});

        myStorage.setItem("__log", JSON.stringify(logs));

        currentCanvas = 0;
        temp = [];
    }, 0);
}

function draw(src) {
    var img = new Image();
    img.src = src;

    img.onload = function() {
        ctx.drawImage(img, 0, 0);
    }
}


console.log('aaaaaaaaaa')

$(function(){
  $('.document_id').click(function(){
    var document_id = $(this).text()
    var document_id_only_number = document_id.replace(/[^0-9]/g, '')
    console.log(document_id_only_number)
    $('.docuent_menu').html('<a class="contract-confirm" href="/signed_contracts">全ての提出された書類を確認する</a>' + '<br><br><br>' +
                            document_id + '<br><br>' +
                            `<a class="contract-confirm" href="/signed_contracts/every_templete_index?templete_id=${document_id_only_number}">提出された書類を確認する</a>` + '<br><br>' +
                            `<a data-confirm="この原本に提出された書類も削除されます。本当に削除しますか？" class="contract-delete" rel="nofollow" data-method="DELETE" href="/contracts/${document_id_only_number}">削除</a>`)
  })
});