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
package pony.net.http.modules.mmodels;

import pony.db.mysql.Field;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.text.tpl.ITplPut;

class Field
{
	public var name:String;
	public var model:Model;
	public var type:Types;
	public var notnull:Bool;
	public var len:Int;
	public var isFile:Bool = false;
	
	public var tplPut:Class<ITplPut> = null;
	
	public function new(?len:Int) {
		type = Types.TEXT;
		notnull = false;
		this.len = len;
	}
	
	public function init(name:String, model:Model):Void {
		this.name = name;
		this.model = model;
		//trace(name);
	}
	
	public function htmlInput(cl:String, act:String, value:String, hidden:Bool=false):String {
		return '';
	}
	
	public function create():pony.db.mysql.Field {
		return {name: name, type: type, flags: notnull ? [Flags.NOT_NULL] : [], length: len};
	}
	
}