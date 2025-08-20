package com.example.mainapp

import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.example.mainapp.databinding.ActivityWebviewBinding

class WebViewActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityWebviewBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWebviewBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupWebView()
    }
    
    private fun setupWebView() {
        val webView = binding.webview
        
        // 启用JavaScript
        webView.settings.javaScriptEnabled = true
        
        // 设置WebViewClient
        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                // 页面加载完成后的处理
            }
        }
        
        // 加载网页
        val url = "https://www.baidu.com"
        webView.loadUrl(url)
    }
    
    override fun onBackPressed() {
        if (binding.webview.canGoBack()) {
            binding.webview.goBack()
        } else {
            super.onBackPressed()
        }
    }
}
