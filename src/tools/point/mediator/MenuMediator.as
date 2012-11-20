package tools.point.mediator 
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import tools.point.events.MenuEvent;
	import tools.point.utils.FileManager;
	import tools.point.utils.CommandManager;
	import tools.point.utils.Metadata;
	import tools.point.view.ToolWindowMenu;
	import tools.point.ToolWindow;
	
	/**
	 * 菜单与其操作命令的中介者
	 * @author Zhenyu Yao
	 */
	public final class MenuMediator 
	{
		
////////////////////////////////////////////////////////////////////////////////////////////////////
// Public Functions
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 构造函数
		 * @param	menu 菜单
		 * @param	fileManager 文件管理器
		 * @param	commandManager 操作命令管理
		 * @author Zhenyu Yao
		 */
		public function MenuMediator(menu : ToolWindowMenu, fileManager : FileManager, commandManager : CommandManager) 
		{
			m_menu = menu;
			m_fileManager = fileManager;
			m_commandManager = commandManager;
			
			m_menu.addEventListener(MenuEvent.NEW, onNewHandler);
			m_menu.addEventListener(MenuEvent.OPEN, onOpenHandler);
			m_menu.addEventListener(MenuEvent.SAVE, onSaveHandler);
			m_menu.addEventListener(MenuEvent.SAVE_AS, onSaveAsHandler);
			m_menu.addEventListener(MenuEvent.UNDO, onUndoHandler);
			m_menu.addEventListener(MenuEvent.REDO, onRedoHandler);
			m_menu.addEventListener(MenuEvent.ABOUT, onAboutHandler);
		}
		
////////////////////////////////////////////////////////////////////////////////////////////////////
// Private Functions
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 新建命令
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onNewHandler(evt : MenuEvent) : void
		{
			var newWindow : ToolWindow = new ToolWindow();
		}
		
		/**
		 * 打开命令
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onOpenHandler(evt : MenuEvent) : void
		{
			m_fileManager.open();
		}
		
		/**
		 * 存储命令
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onSaveHandler(evt : MenuEvent) : void
		{
			if (m_commandManager.currentMetadata != null)
			{
				m_fileManager.save(m_commandManager.currentMetadata);
			}
		}
		
		/**
		 * 另存为命令
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onSaveAsHandler(evt : MenuEvent) : void
		{
			if (m_commandManager.currentMetadata != null)
			{
				m_fileManager.saveAs(m_commandManager.currentMetadata);
			}
		}
		
		/**
		 * 撤销命令
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onUndoHandler(evt : MenuEvent) : void
		{
			m_commandManager.undo();
		}
		
		/**
		 * 重做命令
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onRedoHandler(evt : MenuEvent) : void
		{
			m_commandManager.redo();
		}
		
		/**
		 * 关于 命令
		 * @param	evt 事件对象
		 * @author Zhenyu Yao
		 */
		private function onAboutHandler(evt : MenuEvent) : void
		{
			var url : URLRequest = new URLRequest("http://t.qq.com/stefanie_kaka");
			navigateToURL(url, "_blank");
		}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Private Vars
////////////////////////////////////////////////////////////////////////////////////////////////////

		private var m_menu : ToolWindowMenu = null;
		private var m_fileManager : FileManager = null;
		private var m_commandManager : CommandManager = null;
		
	}

}