package FiniteStateMachine
{
	public interface IStateMachine
	{
		/**
		 * The member function that performs the update on the FSM:
		 * - Test transitions for current state and moves to new state.
		 * - Returns a collection of IActions that result from the current
		 *   state and any transitions, entrances and exits that may occur.
		 * @return A collection of actions produced by evaluating the FSM.
		 */
		function update():Array;
		
		/**
		 * Retrieves the current state of the finite state machine.
		 * @return The current state of the finite state machine.
		 */
		function  get currentState():IState;
		
		/**
		 * Sets the current state of fsm. For setting initial state.
		 */
		function set currentState(type:IState ):void;
	}
}