class RecordPdf < Prawn::Document
  def initialize(sign_url)
    super(page_size: 'A4')

    # 現在の日付取得
    t = Time.now
    nowDate = "#{t.year}年#{t.month}月#{t.day}日"

    # フォント指定して、日本語を使えるようにする
    font 'app/assets/fonts/ipaexm.ttf'

    text_box "#{nowDate}", size: 16, align: :right
    text "署名", size: 24

    # 署名画像を表示
    image sign_url, height: 100

    #下線を引く
    line([0, 630], [500, 630])
    line_width = 1
    undash
    stroke_color("000000")
    stroke
  end
end