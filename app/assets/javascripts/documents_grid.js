// console.log('aaaaaaaaaa')

// $(function(){
//   $('.document_id').click(function(){
//     var document_id = $(this).text()
//     var document_id_only_number = document_id.replace(/[^0-9]/g, '')
//     console.log(document_id_only_number)
//     $('.docuent_menu').html('<a class="contract-confirm" href="/signed_contracts">全ての提出された書類を確認する</a>' + '<br><br><br>' +
//                             document_id + '<br><br>' +
//                             `<a class="contract-confirm" href="/signed_contracts/every_templete_index?templete_id=${document_id_only_number}">提出された書類を確認する</a>` + '<br><br>' +
//                             `<a data-confirm="この原本に提出された書類も削除されます。本当に削除しますか？" class="contract-delete" rel="nofollow" data-method="DELETE" href="/contracts/${document_id_only_number}">削除</a>`)
//   })
// });