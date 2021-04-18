Param(
    # Mandatory : 引数の入力を強制
    [Parameter(Mandatory=$true)]
    [string[]]
    $winshots,

    [Parameter(Mandatory=$true)]
    [String[]]
    $exceldir
)

begin
{
    # Excelファイルを起動
    $xl = New-Object -ComObject Excel.Application -Property @{
        Visible = $false
        Displayalerts = $false
    }
    $wb = $xl.WorkBooks.Add()
}

process
{
    # $winshotsが存在するのか確認
    # 存在しない場合は、処理を終える。
    if (-not (Test-Path $winshots)) {
        $exitCmt = "there is not " + $winshots + "."
        Write-Output $exitCmt
        Write-Output "exit."
        exit
    }

    # $exceldirが存在するのか確認
    if(-not (test-path  $exceldir) ) 
    {
        $exitCmt = "there is not " + $exceldir + "."
        Write-Output $exitCmt
        Write-Output "exit."
        exit
    }
    
    # $winshots配下のイメージのフルパスを配列に保存
    # 複数階層にするとき、避難ディレクトリとして"."で始まる名前のディレクトリ以下にあるイメージは調べない。
    $subDirPaths = ( get-childitem $winshots | Where-Object {$_.name -match "^[^\.]+" -and $_.mode -like "d*"} )

    # Excelファイルの名前を準備
    $exportFileName = ((split-path $winshots -leaf) + (get-date -format MMddhhmm))
    $excelName = join-path (convert-path $exceldir) $exportFileName
    # この変数はもう使いませんよ、と言いたいだけ。
    $exportFileName = $null

    # MsoTriState
    Set-Variable msoFalse 0 -Option Constant -ErrorAction SilentlyContinue
    Set-Variable msoTrue 1 -Option Constant -ErrorAction SilentlyContinue
    # Excelファイル一般の高さ・横幅を指定
    # 現状は、間違った値。デフォルトの行幅・列幅を変える方法が判明すれば、この値にする。
    Set-Variable cellWidth 2 -Option Constant -ErrorAction SilentlyContinue
    Set-Variable cellHeight 15 -Option Constant -ErrorAction SilentlyContinue
    # AddPictureの仕様に合わせて名前を変更?
    # linktofile: 画像を元ファイルとリンクさせるか
    $LinkToFile = $msoFalse
    # savewithdocument: 画像をExcelの中で保存するか
    $SaveWithDocument = $msoTrue
    $Top = $cellHeight * 5
    $Left = $cellWidth * 3
    $Height = $cellHeight * 20 #デフォルトセルの幅変更の方法が判明すれば修正する。
    $Width = $cellWidth * 300 #デフォルトセルの幅変更の方法が判明すれば修正する。

    for($p=1; $p -le $subDirPaths.length; $p++) {
        # 最初の高さを上に戻す
        $Top = $cellHeight * 5
        $Left = $cellWidth * 3
        # ワークブックの追加
        if(-not ($p -eq 1)){$wb.worksheets.add() >$null}
        $wb.Sheets(1).name = $subDirPaths[$p-1].name
        $sh = $wb.Sheets.Item($subDirPaths[$p-1].name)
        # ファイル名.name : ファイル名を表示
        # ファイル名.fullname : フルパスを表示
        $imagePaths = ($subDirPaths[$p-1] | get-childitem  | Where-Object{$_.name -match ".*\.(jpg|png)"} ).fullname

        # arguments to insert the image through the Shapes.AddPicture Method
        for($i=1; $i -le $imagePaths.length; $i++){
            # addpictureの第二変数以降は、ドキュメントの引数名と同じ。
            $img = $sh.Shapes.AddPicture($imagePaths[$i-1], $LinkToFile, $SaveWithDocument, $Left, $Top, $Width, $Height)
            $Top = $Top + $Height + $cellHeight * 5
        }
    }
}

end
{
    # Excelの終了
    $xl.ActiveWorkbook.SaveAS($excelName)
    # その他変数を閉じる。
    #ブックのクローズ
    $wb.Close($true)
    #Excelのクローズ
    $xl.Quit()
    #ガベージコレクタを動作させる
    [GC]::Collect()
}

