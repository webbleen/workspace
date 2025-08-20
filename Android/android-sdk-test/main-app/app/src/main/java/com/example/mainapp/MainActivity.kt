package com.example.mainapp

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.example.mainapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupClickListeners()
    }
    
    private fun setupClickListeners() {
        // 启动WebView按钮
        binding.btnLaunchWebview.setOnClickListener {
            val intent = Intent(this, WebViewActivity::class.java)
            startActivity(intent)
        }
        
        // 自定义Logo按钮
        binding.btnCustomLogo.setOnClickListener {
            // 这里可以添加自定义Logo的逻辑
            // 比如从相册选择图片，或者使用预设的图片资源
            Toast.makeText(this, "自定义Logo功能", Toast.LENGTH_SHORT).show()
        }
    }
}
