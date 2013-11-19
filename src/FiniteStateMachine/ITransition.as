package FiniteStateMachine
{
    import FiniteStateMachine.conditions.ICondition;

	public interface ITransition
	{
		/**
		 * Accesses the state that this transition leads to.
		 * @return The state this transition leads to.
		 */
		function  get targetState():IState;
		
		/**
		 * Sets the target state of this transition.
		 * @param targetState The target state.
		 */
		function  set targetState(type:IState):void;
		
		/**
		 * Generates the action associated with taking this transition.
		 * @return The action associated with taking this transition.
		 */
		function  get action():Function;
		
		/**
		 * Sets the action for enacting the transition.
		 * @param action Transition action.
		 */
		function  set action(type:Function):void;
		
		/**
		 * Sets the condition that determines if the transition is triggered.
		 * @param condition A testable condition.
		 */
		function  set condition(type:Function):void;
		
		/**
		 * Determines if this transition is triggered.
		 * @param game TODO
		 * @return True if triggered, false if not.
		 */
		function  isTriggered():Boolean;
	}
}