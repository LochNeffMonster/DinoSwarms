package FiniteStateMachine
{
    import FiniteStateMachine.conditions.ICondition;

	public class Transition implements ITransition
	{
		private var _targetState:IState;
		private var _action:Function;
		private var _condition:Function;
		/**
		 * 
		 * @param targetState sets the aimed target state
		 * @param action sets the action to be taken when this transition executes
		 * @param condition sets the condition of when this transition is triggered
		 */
		
		public function Transition()
		{
		}
		/**
		 * Accesses the state that this transition leads to.
		 * @return The state this transition leads to.
		 */
		public function get targetState():IState
		{
			return _targetState;
		}
		
		public function set targetState(type:IState):void
		{
			_targetState = type;
		}
		/**
		 * Generates the action associated with taking this transition.
		 * @return The action associated with taking this transition.
		 */
		public function get action():Function
		{
			return _action;
		}
		
		public function set action(type:Function):void
		{
			_action = type;
		}
		/**
		 * Sets the condition that determines if the transition is triggered.
		 * @param condition A testable condition.
		 */
		public function set condition(type:Function):void
		{
			_condition = type;
		}
		
		public function isTriggered():Boolean
		{
			trace(_condition);
			return _condition();
		}
	}
}