//
//  UIFont+Extension.swift
//  Shared
//
//  Created by ukseung.dev on 12/5/24.
//

import SwiftUI

public extension Font {
    static func black(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.black.swiftUIFont(size: size)
    }

    static func bold(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.bold.swiftUIFont(size: size)
    }

    static func extraBold(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.extraBold.swiftUIFont(size: size)
    }

    static func extraLight(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.extraLight.swiftUIFont(size: size)
    }

    static func light(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.light.swiftUIFont(size: size)
    }

    static func medium(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.medium.swiftUIFont(size: size)
    }

    static func regular(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.regular.swiftUIFont(size: size)
    }

    static func semiBold(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.semiBold.swiftUIFont(size: size)
    }

    static func thin(_ size: CGFloat) -> Font {
        return SharedFontFamily.Pretendard.thin.swiftUIFont(size: size)
    }
}
