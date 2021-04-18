# 添加 System.speech.dll 引用
Add-Type -AssemblyName System.speech
# 创建 SpeechSynthesizer 对象
$syn=New-Object System.Speech.Synthesis.SpeechSynthesizer
$syn.Rate=-1
$syn.Volume=100
#Set-AudioVolum -Volum 1

1..3 | ForEach-Object {
    $syn.Speak("请注意，王瑛小朋友，你睡觉的时间到了，明天早晨还要早点起床去上学。")
}
$syn.Speak("现在倒计时关电脑：五，四，三，二，一，关机")
#Set-AudioVolum -Volum 0.2
Stop-Computer -Force