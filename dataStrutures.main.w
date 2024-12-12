bring cloud;

struct productType{
    vale: str;
    other: num;
}
    
//declairing the interaface inflight so we can actauly use it,
//this also make it so we do not have to declair any of the feilds / methods as inflight
inflight interface Sumtree{
    toStr(): str;
    isNode(): bool;
    addVal(val: num): void;
}

inflight class SumTreeEmpty impl Sumtree{
    pub toStr(): str{
        return "Empty";
    }

    pub isNode():bool{
        return false;
    }

    pub addVal(val: num){

    }
}

inflight class SumTreeNode impl Sumtree{
    new(val:num, left:Sumtree, right:Sumtree){
        this.value = val;
        this.left = left;
        this.right = right;
    }
    var value: num;
    var left: Sumtree;
    var right: Sumtree;

    pub isNode():bool{
        return true;
    }
    

    pub toStr(): str{
        return "Node of {this.value} ({this.left.toStr()} {this.right.toStr()})";
    }

    pub addVal(val: num){
        if(val < this.value){
            //go right
            
            if (this.right.isNode()){
                this.right.addVal(val);
            }else{
                this.right = new SumTreeNode(val,new SumTreeEmpty(), new SumTreeEmpty());
            }
        }else{
            //go left
            if(this.left.isNode()){
                this.left.addVal(val);
            }else{
                this.left = new SumTreeNode(val,new SumTreeEmpty(), new SumTreeEmpty());
            }
        }
    }    
}


let useIt = inflight (input: Json?) => {
    let dez = productType{other: 7,vale: "HI"};

    log("product type value: "+dez.vale+" other value: {dez.other}");

    let emptyTest = new SumTreeEmpty();
    log("Empty Tree: "+emptyTest.toStr());
    let basicTree = new SumTreeNode(5,new SumTreeEmpty(),new SumTreeEmpty());
    log("Basic Tree: "+basicTree.toStr());

    let betterTree = new SumTreeNode(8, new SumTreeEmpty(), new SumTreeEmpty());
    let intoTree = [0,72, 15, 43, 8, 91, 56, 24, 33, 7, 62, 48, 19, 77, 4, 61];
    for value in intoTree{
        betterTree.addVal(value);
    }
    log("Better Tree: "+betterTree.toStr());
};

new cloud.Function(useIt); 
