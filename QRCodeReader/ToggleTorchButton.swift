/*
 * QRCodeReader.swift
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

/// The toggle torch button.
@IBDesignable final class ToggleTorchButton: UIButton {
  @IBInspectable var edgeColor: UIColor = UIColor.white {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var fillColor: UIColor  = UIColor.lightGray {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var edgeHighlightedColor: UIColor = UIColor.white
  @IBInspectable var fillHighlightedColor: UIColor = UIColor.darkGray

  override func draw(_ rect: CGRect) {
    // Colors
    let paintColor  = (self.state != .highlighted) ? fillColor : fillHighlightedColor
    let strokeColor = (self.state != .highlighted) ? edgeColor : edgeHighlightedColor

    let width   = rect.width
    let height  = rect.height
    let centerX = width / 2
    let centerY = height / 2

    let strokeLineWidth: CGFloat = 2
    let circleRadius: CGFloat    = width / 10
    let lineLength: CGFloat      = width / 10
    let lineOffset: CGFloat      = width / 10
    let lineOriginFromCenter     = circleRadius + lineOffset

    //Circle
    let circlePath = UIBezierPath()
    circlePath.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: circleRadius, startAngle: 0.0, endAngle: CGFloat(M_PI), clockwise: true)
    circlePath.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: circleRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: true)

    // Draw beams
    paintColor.setFill()

    for i in 0 ..< 8 {
      let angle = ((2 * CGFloat(M_PI)) / 8) * CGFloat(i);

      let startPoint = CGPoint(x: centerX + cos(angle) * lineOriginFromCenter, y: centerY + sin(angle) * lineOriginFromCenter);
      let endPoint   = CGPoint(x: centerX + cos(angle) * (lineOriginFromCenter + lineLength), y: centerY + sin(angle) * (lineOriginFromCenter + lineLength));

      let beam = linePathWithStartPoint(startPoint, endPoint: endPoint, thickness: strokeLineWidth)
      beam.stroke()
    }

    // Draw circle
    strokeColor.setStroke()

    circlePath.lineWidth = strokeLineWidth
    circlePath.fill()
    circlePath.stroke()
  }

  fileprivate func linePathWithStartPoint(_ startPoint: CGPoint, endPoint: CGPoint, thickness: CGFloat) -> UIBezierPath {
    let linePath = UIBezierPath()

    linePath.move(to: startPoint)
    linePath.addLine(to: endPoint)
    linePath.lineCapStyle = .round
    linePath.lineWidth = thickness

    return linePath
  }

  // MARK: - UIResponder Methods

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    setNeedsDisplay()
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)

    setNeedsDisplay()
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    setNeedsDisplay()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)

    setNeedsDisplay()
  }
}
