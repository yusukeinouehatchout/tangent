$(function(){
  $('.document_id').click(function(){
    var document_id = $(this).text()
    var document_id_only_number = document_id.replace(/[^0-9]/g, '')
    var sign_number = $(this).next('.sub-info').text()
    $('.docuent_menu').html('<a class="contract-confirm" href="/signed_contracts">全ての提出された書類を確認する</a>' + '<br><br><br>' +
                            '<h3>' + document_id + '</h3>' + '<br><br>' +
                            sign_number + '<br><br>' +
                            `<a class="contract-confirm" href="/signed_contracts/every_templete_index?templete_id=${document_id_only_number}">提出された書類を確認する</a>` + '<br><br>' +
                            `<a data-confirm="この原本に提出された書類も削除されます。本当に削除しますか？" class="contract-delete" rel="nofollow" data-method="DELETE" href="/contracts/${document_id_only_number}">削除</a>`)
  })

  $('.signer_name').click(function(){
    var signed_document_id = $(this).next('.contract-delete').attr('href').replace(/[^0-9]/g, '')
    var signer_name = $(this).text()
    var signed_datetime = $(this).nextAll('.sub-info').text()
    console.log(signed_datetime)

    $('.docuent_menu').html('<h3>' + signer_name + '</h3>' + '<br><br>' +
                            signed_datetime + '<br><br>' +
                            `<a data-confirm="削除しますか？" class="contract-delete" rel="nofollow" data-method="DELETE" href="/signed_contracts/${signed_document_id}">削除</a>`)
  })
});