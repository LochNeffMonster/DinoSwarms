package FiniteStateMachine
{
	public class State implements IState
	{
		private var _currentAction:Function;
		private var _entryAction:Function;
		private var _exitAction:Function;
		private var _transitions:Array = [];
		/**
		 * 
		 * @param entryAction sets the entry action that will be called on entry into this state
		 * @param exitAction sets the exit action that will be called when leaving this state
		 * @param transitions sets the transitions to call from this state to another
		 */
		public function State()
		{
		}
		/**
		 * Determines the action appropriate for being in this state. 
		 * @return Action for being in this state.
		 */
		public function get action():Function
		{
			return _currentAction;
		}
		
		public function set action(type:Function):void
		{
			_currentAction = type;
		}
		
		public function get entryAction():Function
		{
			return _entryAction;
		}
		
		public function set entryAction(type:Function):void
		{
			_entryAction = type;
		}
		
		public function get exitAction():Function
		{
			return _exitAction;
		}
		
		public function set exitAction(type:Function):void
		{
			_exitAction = type;
		}
		
		public function get transitions():Array
		{
			return _transitions;
		}
		
		public function set transitions(type:Array):void
		{
			_transitions = type;
		}
	}
}