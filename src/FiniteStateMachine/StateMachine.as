package FiniteStateMachine
{
	public class StateMachine implements IStateMachine
	{
		private var _currentState:IState;
		public var transitions:Array = [];
		
		public function StateMachine()
		{
		}
		/**
		 * The member function that performs the update on the FSM:
		 * - Test transitions for current state and moves to new state.
		 * - Returns a collection of IActions that result from the current
		 *   state and any transitions, entrances and exits that may occur.
		 * @return A collection of actions produced by evaluating the FSM.
		 */
        //OLD MCCLUSTER IS FUCKING COMING FOR YOU
		public function update():Array
		{
			var actions:Array = [];
			for(var trans:ITransition in transitions){
				if(trans.isTriggered()){
					if(_currentState.exitAction){
						actions.push(_currentState.exitAction);
					}
					if(trans.action){
						actions.push(trans.action);
					}
					_currentState = trans.targetState;
					if(_currentState.entryAction){
						actions.push(_currentState.entryAction);
					}
					break;
				}
			}
			actions.push(_currentState.action);
			return actions;
		}
		/**
		 * Retrieves the current state of the finite state machine.
		 * @return The current state of the finite state machine.
		 */
		public function get currentState():IState
		{
			return _currentState;
		}
		
		public function set currentState(type:IState):void
		{
			_currentState = type;
		}
	}
}