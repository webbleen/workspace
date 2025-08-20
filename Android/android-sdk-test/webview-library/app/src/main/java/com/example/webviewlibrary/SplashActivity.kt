package com.example.webviewlibrary

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import com.example.webviewlibrary.databinding.ActivitySplashBinding

class SplashActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivitySplashBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySplashBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        // 延迟2秒后跳转到主页面
        Handler(Looper.getMainLooper()).postDelayed({
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
            finish()
        }, 2000)
    }
    
    /**
     * 设置自定义Logo
     * @param logoResId 自定义Logo的资源ID
     */
    fun setCustomLogo(logoResId: Int) {
        binding.ivLogo.setImageResource(logoResId)
    }
}

