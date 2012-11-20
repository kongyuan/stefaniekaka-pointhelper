package tools.point.view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import fl.controls.TextInput;
	import fl.controls.Label;
	import fl.controls.ComboBox;
	import fl.controls.TextArea;
	import flash.geom.Point;
	import tools.point.events.ChangeDivideValueEvent;
	import tools.point.events.ChangeRowAndColEvent;
	import tools.point.utils.Metadata;
	
	/**
	 * 打印信息窗口
	 * @author Zhenyu Yao
	 */
	public final class PrintMessageView extends Sprite 
	{

////////////////////////////////////////////////////////////////////////////////////////////////////
// Public Functions
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 构造函数
		 * @author Zhenyu Yao
		 */
		public function PrintMessageView() 
		{
			// Row
			var lblRow : Label = new Label();
			lblRow.text = "Row: ";
			this.addChild(lblRow);
			
			m_txtRow = new TextInput();
			m_txtRow.restrict = "0123456789";
			m_txtRow.text = "1";
			m_txtRow.x = 32;
			m_txtRow.width = 60;
			m_txtRow.addEventListener(Event.CHANGE, onRowOrColValueChangeHandler);
			this.addChild(m_txtRow);
			
			// Col
			var lblCol : Label = new Label();
			lblCol.text = "Col: ";
			lblCol.x = 100;
			this.addChild(lblCol);
			
			m_txtCol = new TextInput();
			m_txtCol.restrict = "0123456789";
			m_txtCol.text = "1";
			m_txtCol.x = 132;
			m_txtCol.width = 60;
			m_txtCol.addEventListener(Event.CHANGE, onRowOrColValueChangeHandler);
			this.addChild(m_txtCol);
			
			// Print type combobox
			var lblPrintType : Label = new Label();
			lblPrintType.text = "PrintType: ";
			lblPrintType.y = 28;
			this.addChild(lblPrintType);
			
			m_comboBoxPrintType = new ComboBox();
			m_comboBoxPrintType.addItem({label: "Coordinate"});
			m_comboBoxPrintType.addItem({label: "Divide Value"});
			m_comboBoxPrintType.x = 60;
			m_comboBoxPrintType.y = 28;
			m_comboBoxPrintType.addEventListener(Event.CHANGE, onComboBoxPrintTypeChangeHandler);
			this.addChild(m_comboBoxPrintType);
			
			// Divide value
			m_valueContainer = new Sprite();
			m_valueContainer.y = 56;
			this.addChild(m_valueContainer);
			
			var lblDivideValue : Label = new Label();
			lblDivideValue.text = "Divide value: ";
			m_valueContainer.addChild(lblDivideValue);
			
			m_txtDivideValue = new TextInput();
			m_txtDivideValue.restrict = "0123456789.";
			m_txtDivideValue.text = "1";
			m_txtDivideValue.x = 80;
			m_valueContainer.addEventListener(Event.CHANGE, onDivideValueChangeHandler);
			m_valueContainer.addChild(m_txtDivideValue);
			m_valueContainer.visible = false;
			
			// Message area
			m_txtMessage = new TextArea();
			m_txtMessage.width = 588;
			m_txtMessage.height = 140;
			m_txtMessage.x = 200;
			m_txtMessage.editable = false;
			this.addChild(m_txtMessage);
			
			reset();
		}
		
		/**
		 * 重置视图
		 * @author Zhenyu Yao
		 */
		public function reset() : void
		{
			m_txtRow.text = "1";
			m_txtCol.text = "1";
			m_comboBoxPrintType.selectedIndex = 0;
			m_valueContainer.visible = false;
			m_txtDivideValue.text = "1";
			m_txtMessage.text = "";
		}
		
		/**
		 * 打印输出数据
		 * @param	data 元数据
		 * @author Zhenyu Yao
		 */
		public function printData(data : Metadata) : void
		{
			m_txtRow.text = data.rows.toString();
			m_txtCol.text = data.cols.toString();
			
			m_txtMessage.text = "{\n";
			var rows : int = data.rows;
			var cols : int = data.cols;
			var divideValue : Number = parseFloat(m_txtDivideValue.text);
			for (var i : int = 0; i < rows; ++i)
			{
				for (var j : int = 0; j < cols; ++j)
				{
					m_txtMessage.appendText("\t[" + i + "][" + j + "]\n");
					m_txtMessage.appendText("\t{\n");
					var points : Vector.<Point> = data.getPoints(i, j);
					for each (var p : Point in points)
					{
						m_txtMessage.appendText("\t\t");
						var tmp : String = "{" + p.x / divideValue + ", " + p.y / divideValue + "},\n";
						m_txtMessage.appendText(tmp);
					}
					m_txtMessage.appendText("\t}\n");
				}
				
				if (i != rows - 1)
				{
					m_txtMessage.appendText("<-------------------------------------------- [行]分割线 -------------------------------------------->\n");
				}
			}
			m_txtMessage.appendText("}\n");
		}
		
////////////////////////////////////////////////////////////////////////////////////////////////////
// Private Functions
////////////////////////////////////////////////////////////////////////////////////////////////////	
		
		/**
		 * 行或列的文本框文本改变事件
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onRowOrColValueChangeHandler(evt : Event) : void
		{
			checkTextInput(m_txtRow);
			checkTextInput(m_txtCol);
			
			var row : int = parseInt(m_txtRow.text);
			var col : int = parseInt(m_txtCol.text);
			
			var changeRowAndColEvent : ChangeRowAndColEvent = new ChangeRowAndColEvent(ChangeRowAndColEvent.CHANGE_ROW_AND_COL, row, col);
			this.dispatchEvent(changeRowAndColEvent);
		}
		
		/**
		 * 输出类型的组合框选项改变事件
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onComboBoxPrintTypeChangeHandler(evt : Event) : void
		{
			m_valueContainer.visible = m_comboBoxPrintType.selectedIndex > 0;
			m_txtDivideValue.text = "1";
			
			var divideValue : Number = parseFloat(m_txtDivideValue.text);
			var changeDivideValueEvt : ChangeDivideValueEvent = new ChangeDivideValueEvent(ChangeDivideValueEvent.CHANGE_DIVIDE_VALUE, divideValue);
			this.dispatchEvent(changeDivideValueEvt);
		}
		
		/**
		 * 除值的文本框文本改变事件
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onDivideValueChangeHandler(evt : Event) : void
		{
			checkTextInput(m_txtDivideValue);
			
			var divideValue : Number = parseFloat(m_txtDivideValue.text);
			var changeDivideValueEvt : ChangeDivideValueEvent = new ChangeDivideValueEvent(ChangeDivideValueEvent.CHANGE_DIVIDE_VALUE, divideValue);
			this.dispatchEvent(changeDivideValueEvt);
		}
		
		/**
		 * 检测输入框的操作
		 * @param	txtInput 输入框对象
		 * @author Zhenyu Yao
		 */
		private function checkTextInput(txtInput : TextInput) : void
		{
			if (txtInput.text == ""
				|| txtInput.text.charAt(0) == "0"
				|| txtInput.text.charAt(0) == ".")
			{
				txtInput.text = "1";
			}
		}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Private vars
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private var m_txtRow : TextInput = null;
		private var m_txtCol : TextInput = null;
		private var m_txtDivideValue: TextInput = null;
		private var m_comboBoxPrintType : ComboBox = null;
		private var m_valueContainer : Sprite = null;
		private var m_txtMessage : TextArea = null;
	}

}