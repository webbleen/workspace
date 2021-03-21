class Point
{
    ## 使用PowerShell正常的变量语法来定义两个属性，
    ## 你也可以限制变量的属性。
    ## 使用正常的类型限制符:
    ## [type] $VarName = initialValue
    $X = 0
    $Y = 0
    ## 定义一个方法（返回值为Void）
    ## 定义两个参数，
    ## 当然你可以给参数添加类型
    [void] Move($xOffset, $yOffset)
    {
        $this.X += $xOffset
        $this.Y += $yOffset
    }
}
## 创建一个Point 类型，并调用方法
$point = [Point]::new()
$point.Move(10, 20)
$point