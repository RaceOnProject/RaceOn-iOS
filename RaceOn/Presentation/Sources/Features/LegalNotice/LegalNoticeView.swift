//
//  LegalNoticeView.swift
//  Presentation
//
//  Created by ukseung.dev on 12/16/24.
//

import SwiftUI
import WebKit

// WKWebView를 SwiftUI에서 사용할 수 있도록 래핑
struct WebView: UIViewRepresentable {
    
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        // WKWebView 생성
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // URL을 로드
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct LegalNoticeView: View {

    @EnvironmentObject var router: Router
    var type: SettingCategory
    
    var body: some View {
        ZStack {
            ColorConstants.gray6
                .ignoresSafeArea()
            
            // 웹 페이지를 로드하는 WebView 사용
            WebView(url: URL(string: type.urlString)!)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarView.leadingItems {
                        router.pop()
                    }
                    ToolbarView.principalItem(title: type.title)
                }
                .toolbarBackground(ColorConstants.gray6, for: .navigationBar)
        }
    }
}

#Preview {
    LegalNoticeView(
        type: .privacyPolicy
    )
    .environmentObject(Router())
}
