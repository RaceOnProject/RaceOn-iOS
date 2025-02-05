//
//  SwiftUIView.swift
//  Presentation
//
//  Created by inforex on 12/13/24.
//

import SwiftUI
import ComposableArchitecture
import Domain

public enum MatchingProcess: Equatable {
    case waiting
    case failed(reason: String)
    case successed(seconds: Int)
    
    var isFailed: Bool {
        if case .failed(_) = self {
            return true
        }
        return false
    }
    
    var title: String {
        switch self {
        case .waiting: return "친구 매칭을 진행 중이에요"
        case .failed: return "매칭이 실패하였습니다"
        case .successed: return "매칭이 완료 되었습니다"
        }
    }
    
    var subTitle: String {
        switch self {
        case .waiting: return "조금만 기다려 주세요"
        case .failed(let reason): return reason
        case .successed(let seconds): return "\(seconds)초 뒤 게임이 시작됩니다"
        }
    }
    
    var image: Image {
        switch self {
        case .waiting: return ImageConstants.graphicWaiting
        case .failed: return ImageConstants.graphicRefuse
        case .successed: return ImageConstants.graphicMatching
        }
    }
}

public struct MatchingProcessView: View {
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewStore: ViewStoreOf<MatchingProcessFeature>
    let store: StoreOf<MatchingProcessFeature>
    
    public init(store: StoreOf<MatchingProcessFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        ZStack {
            ColorConstants.gray6
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                
                title
                
                image
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .overlay(alignment: .bottom) {
                if viewStore.state.process.isFailed {
                    backButton
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewStore.send(.onAppear)
        }
        .onChange(of: viewStore.state.webSocketDisconnect) { handler in
            handler ? router.pop() : nil
        }
        .onChange(of: viewStore.state.isReadyForNextScreen) { handler in
            
            let distance = viewStore.state.distance
            handler ? router.push(screen: .game(distance)) : nil
        }
    }
    
    @ViewBuilder
    var topBar: some View {
        HStack {
            if !viewStore.state.process.isFailed {
                Button {
                    print("취소 탭")
                    router.pop()
                } label: {
                    Text("취소")
                        .frame(width: 26, height: 23)
                        .font(.semiBold(15))
                        .foregroundStyle(ColorConstants.gray3)
                }
            }
            Spacer()
        }
        .frame(height: 54)
    }
    
    @ViewBuilder
    var title: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewStore.state.process.title)
                    .font(.bold(24))
                    .foregroundStyle(.white)
                
                Text(viewStore.state.process.subTitle)
                    .font(.regular(16))
                    .foregroundStyle(ColorConstants.gray3)
            }
            
            Spacer()
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    var image: some View {
        viewStore.state.process.image
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal, 15)
            .padding(.top, 108)
    }
    
    @ViewBuilder
    var backButton: some View {
        Button {
            print("돌아가기 탭")
            router.pop()
        } label: {
            Text("홈으로 돌아가기")
                .font(.semiBold(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 54)
        .background(ColorConstants.primaryNormal)
        .cornerRadius(30)
        .padding(.horizontal, 20)
        .padding(.bottom, 18)
    }
}
