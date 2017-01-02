//
//  ImplicitConversions.swift
//  AntlerKit
//
//  Created by Charlie Imhoff on 1/1/17.
//  Copyright © 2017 Charlie Imhoff. All rights reserved.
//

import Foundation

func +(lhs: Float, rhs: CGFloat) -> Float {
	return lhs + Float(rhs)
}
func +(lhs: CGFloat, rhs: Float) -> CGFloat {
	return lhs + CGFloat(rhs)
}
func +=(lhs: inout Float, rhs: CGFloat) {
	lhs = lhs + rhs
}
func +=(lhs: inout CGFloat, rhs: Float) {
	lhs = lhs + rhs
}

func -(lhs: Float, rhs: CGFloat) -> Float {
	return lhs - Float(rhs)
}
func -(lhs: CGFloat, rhs: Float) -> CGFloat {
	return lhs - CGFloat(rhs)
}
func -=(lhs: inout Float, rhs: CGFloat) {
	lhs = lhs - rhs
}
func -=(lhs: inout CGFloat, rhs: Float) {
	lhs = lhs - rhs
}


func /(lhs: Float, rhs: CGFloat) -> Float {
	return lhs / Float(rhs)
}
func /(lhs: CGFloat, rhs: Float) -> CGFloat {
	return lhs / CGFloat(rhs)
}

func *(lhs: Float, rhs: CGFloat) -> Float {
	return lhs * Float(rhs)
}
func *(lhs: CGFloat, rhs: Float) -> CGFloat {
	return lhs * CGFloat(rhs)
}
