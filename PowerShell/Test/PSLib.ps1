Function Factorial([int]$n)
{
    $total=1
    for($i=1;$i -le $n;$i++)
    {
        $total*=$i
    }
    return $total
}