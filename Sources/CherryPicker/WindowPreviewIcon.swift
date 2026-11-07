import SwiftUI

/// Wektorowa miniatura ekranu z dynamicznie renderowanym obrysem okna.
/// Odwzorowuje dokładną pozycję i rozmiar okna na wyświetlaczu w stylu natywnego macOS.
public struct WindowPreviewIcon: View {
    public let action: WindowAction
    public var size: CGFloat = 28

    public init(action: WindowAction, size: CGFloat = 28) {
        self.action = action
        self.size = size
    }

    public var body: some View {
        let rect = action.normalizedRect
        let innerPadding: CGFloat = size * (3.5 / 28.0)
        let innerSize = size - (innerPadding * 2)

        ZStack(alignment: .topLeading) {
            // Tło miniatury: zaokrąglony kafelek z gradientem w kolorystyce akcentu macOS
            RoundedRectangle(cornerRadius: size * (7.0 / 28.0), style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.22, green: 0.74, blue: 0.97), // #38bdf8
                            Color(red: 0.15, green: 0.39, blue: 0.92)  // #2563eb
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: size * (7.0 / 28.0), style: .continuous)
                        .stroke(Color.white.opacity(0.35), lineWidth: 0.5)
                )
                .shadow(color: Color(red: 0.15, green: 0.39, blue: 0.92).opacity(0.35), radius: 3, x: 0, y: 1.5)

            // Obszar roboczy wyświetlacza
            RoundedRectangle(cornerRadius: size * (3.5 / 28.0), style: .continuous)
                .fill(Color.black.opacity(0.18))
                .frame(width: innerSize, height: innerSize)
                .offset(x: innerPadding, y: innerPadding)

            // Aktywny obszar okna: biały zaokrąglony prostokąt umieszczony w wyliczonej pozycji
            RoundedRectangle(cornerRadius: max(1.5, size * (2.0 / 28.0)), style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.5)
                .frame(
                    width: max(2.5, innerSize * rect.width),
                    height: max(2.5, innerSize * rect.height)
                )
                .offset(
                    x: innerPadding + (innerSize * rect.origin.x),
                    y: innerPadding + (innerSize * rect.origin.y)
                )
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Normalizacja Geometrii Układu Okna
extension WindowAction {
    /// Względne współrzędne i wymiary okna w przestrzeni [0.0 ... 1.0]
    public var normalizedRect: CGRect {
        switch self {
        // Połowy (Halves)
        case .leftHalf:
            return CGRect(x: 0, y: 0, width: 0.5, height: 1.0)
        case .rightHalf:
            return CGRect(x: 0.5, y: 0, width: 0.5, height: 1.0)
        case .topHalf:
            return CGRect(x: 0, y: 0, width: 1.0, height: 0.5)
        case .bottomHalf:
            return CGRect(x: 0, y: 0.5, width: 1.0, height: 0.5)
        case .centerHalf:
            return CGRect(x: 0.25, y: 0, width: 0.5, height: 1.0)

        // Jedna trzecia (Thirds - 1/3)
        case .firstThird:
            return CGRect(x: 0, y: 0, width: 1.0 / 3.0, height: 1.0)
        case .centerThird:
            return CGRect(x: 1.0 / 3.0, y: 0, width: 1.0 / 3.0, height: 1.0)
        case .lastThird:
            return CGRect(x: 2.0 / 3.0, y: 0, width: 1.0 / 3.0, height: 1.0)
        case .topThird:
            return CGRect(x: 0, y: 0, width: 1.0, height: 1.0 / 3.0)
        case .middleThird:
            return CGRect(x: 0, y: 1.0 / 3.0, width: 1.0, height: 1.0 / 3.0)
        case .bottomThird:
            return CGRect(x: 0, y: 2.0 / 3.0, width: 1.0, height: 1.0 / 3.0)

        // Dwie trzecie (Two Thirds - 2/3)
        case .firstTwoThirds:
            return CGRect(x: 0, y: 0, width: 2.0 / 3.0, height: 1.0)
        case .centerTwoThirds:
            return CGRect(x: 1.0 / 6.0, y: 0, width: 2.0 / 3.0, height: 1.0)
        case .lastTwoThirds:
            return CGRect(x: 1.0 / 3.0, y: 0, width: 2.0 / 3.0, height: 1.0)
        case .topTwoThirds:
            return CGRect(x: 0, y: 0, width: 1.0, height: 2.0 / 3.0)
        case .bottomTwoThirds:
            return CGRect(x: 0, y: 1.0 / 3.0, width: 1.0, height: 2.0 / 3.0)
        case .topCenterTwoThirds:
            return CGRect(x: 1.0 / 6.0, y: 0, width: 2.0 / 3.0, height: 2.0 / 3.0)
        case .bottomCenterTwoThirds:
            return CGRect(x: 1.0 / 6.0, y: 1.0 / 3.0, width: 2.0 / 3.0, height: 2.0 / 3.0)

        // Ćwiartki (Quarters)
        case .topLeftQuarter:
            return CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        case .topRightQuarter:
            return CGRect(x: 0.5, y: 0, width: 0.5, height: 0.5)
        case .bottomLeftQuarter:
            return CGRect(x: 0, y: 0.5, width: 0.5, height: 0.5)
        case .bottomRightQuarter:
            return CGRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)

        // Jedna czwarta (Fourths - 1/4)
        case .firstFourth:
            return CGRect(x: 0, y: 0, width: 0.25, height: 1.0)
        case .secondFourth:
            return CGRect(x: 0.25, y: 0, width: 0.25, height: 1.0)
        case .thirdFourth:
            return CGRect(x: 0.5, y: 0, width: 0.25, height: 1.0)
        case .lastFourth:
            return CGRect(x: 0.75, y: 0, width: 0.25, height: 1.0)
        case .topFirstFourth:
            return CGRect(x: 0, y: 0, width: 1.0, height: 0.25)
        case .topSecondFourth:
            return CGRect(x: 0, y: 0.25, width: 1.0, height: 0.25)
        case .topThirdFourth:
            return CGRect(x: 0, y: 0.5, width: 1.0, height: 0.25)
        case .topLastFourth:
            return CGRect(x: 0, y: 0.75, width: 1.0, height: 0.25)

        // Trzy czwarte (Three Fourths - 3/4)
        case .firstThreeFourths:
            return CGRect(x: 0, y: 0, width: 0.75, height: 1.0)
        case .centerThreeFourths:
            return CGRect(x: 0.125, y: 0, width: 0.75, height: 1.0)
        case .lastThreeFourths:
            return CGRect(x: 0.25, y: 0, width: 0.75, height: 1.0)
        case .topThreeFourths:
            return CGRect(x: 0, y: 0, width: 1.0, height: 0.75)
        case .bottomThreeFourths:
            return CGRect(x: 0, y: 0.25, width: 1.0, height: 0.75)

        // Szóstki (Sixths - 1/6)
        case .topLeftSixth:
            return CGRect(x: 0, y: 0, width: 1.0 / 3.0, height: 0.5)
        case .topCenterSixth:
            return CGRect(x: 1.0 / 3.0, y: 0, width: 1.0 / 3.0, height: 0.5)
        case .topRightSixth:
            return CGRect(x: 2.0 / 3.0, y: 0, width: 1.0 / 3.0, height: 0.5)
        case .bottomLeftSixth:
            return CGRect(x: 0, y: 0.5, width: 1.0 / 3.0, height: 0.5)
        case .bottomCenterSixth:
            return CGRect(x: 1.0 / 3.0, y: 0.5, width: 1.0 / 3.0, height: 0.5)
        case .bottomRightSixth:
            return CGRect(x: 2.0 / 3.0, y: 0.5, width: 1.0 / 3.0, height: 0.5)

        // Maksymalizacja i skalowanie
        case .maximize:
            return CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        case .almostMaximize:
            return CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.9)
        case .maximizeHeight:
            return CGRect(x: 0.25, y: 0, width: 0.5, height: 1.0)
        case .maximizeWidth:
            return CGRect(x: 0, y: 0.25, width: 1.0, height: 0.5)
        case .reasonableSize:
            return CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        case .center:
            return CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
        }
    }
}
