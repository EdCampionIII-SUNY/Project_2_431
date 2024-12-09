bring cloud;


let map = inflight (list: MutArray<str>, mapFunction: (str):str) => {
    let out = MutArray<str>[];
    for elem in list{
        out.insert(out.length,mapFunction(elem));
    }
    return out;
};

let filter = inflight (list: MutArray<str>, filterFunc: (str):bool) => {
    let out = MutArray<str>[];
    for elem in list{
        if(filterFunc(elem)){
            out.insert(out.length,elem);
        }
    }
    return out;
};

let reduceToNum = inflight (list: MutArray<str>, reductionFunc: (str,num):num) => {
    let var out = 0;
    for elem in list{
        out = reductionFunc(elem,out);
    }
    return out;
};



new cloud.Function(inflight (input) => {
    let inputString = input?.asStr()??"";
    if( inputString == ""){
        log("INVALID INPUT input should be a cama seperated list of things");
        return "INVALID INPUT";
    }
    let list = inputString.split(",");
    log(list.length);
    let mutableList = list.copyMut();

    let mapped = map(mutableList,(inp:str)=>{
        //reverse string function
        let var out = "";
        for i in inp.length-1..0{
            out = out.concat(inp.at(i));
        }
        return out;
    });
    log(mapped.join(","));

    let filterd = filter(mapped, (inp:str)=>{
        return inp.length>7;
    });
    log(filterd.join(","));

    let reduced = reduceToNum(filterd, (inp:str, acc:num) => {
        return acc + inp.length;
    });
    log(reduced);
});
