package com.example.webviewlibrary

import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.example.webviewlibrary.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
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
        val url = getString(R.string.web_url)
        webView.loadUrl(url)
    }
    
    /**
     * 加载自定义URL
     * @param url 要加载的URL
     */
    fun loadCustomUrl(url: String) {
        binding.webview.loadUrl(url)
    }
    
    override fun onBackPressed() {
        if (binding.webview.canGoBack()) {
            binding.webview.goBack()
        } else {
            super.onBackPressed()
        }
    }
}
