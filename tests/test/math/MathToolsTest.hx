/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package math;

import pony.math.MathTools;

using pony.Tools;
using massive.munit.Assert;

class MathToolsTest 
{

	@Test
	public function testRange():Void
	{
		MathTools.range(3, 7).areEqual(4);
		MathTools.range(-2, 3).areEqual(5);
		MathTools.range(4, 1).areEqual(3);
		MathTools.range(1, -8).areEqual(9);
		MathTools.range(-1, -8).areEqual(7);
	}

	@Test
	public function testClipSmoothFrames():Void {
		MathTools.clipSmoothFrames(4, 5).equal([4, 0, 1]).isTrue();
	}

	@Test
	public function testClipSmoothOddPlan():Void {
		MathTools.clipSmoothOddPlan(0, 5).equal([0, 1, 2]).isTrue();
		MathTools.clipSmoothOddPlan(1, 5).equal([1, 0, 3]).isTrue();
		MathTools.clipSmoothOddPlan(4, 5).equal([0, 2, 3]).isTrue();
		MathTools.clipSmoothOddPlan(3, 5).equal([1, 2, 0]).isTrue();
		MathTools.clipSmoothOddPlan(3, 4).equal([1, 0, 3]).isTrue();
		MathTools.clipSmoothOddPlan(2, 4).equal([0, 1, 2]).isTrue();
		MathTools.clipSmoothOddPlan(1, 4).equal([1, 0, 3]).isTrue();
	}

}