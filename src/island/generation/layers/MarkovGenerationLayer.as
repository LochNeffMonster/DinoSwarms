package island.generation.layers
{
import island.generation.GenerationLayer;
import island.generation.MarkovModel;

public class MarkovGenerationLayer extends GenerationLayer
{
	public function MarkovGenerationLayer(){
		//TODO
	}
	
	override public function apply(tilemap:Vector.<Vector.<int>>, resolution:int):Vector.<Vector.<int>>{
		//TODO
		return null;
	}
	
	public function setModel(tileType:int, model:MarkovModel):void{
		//TODO
	}
}

}