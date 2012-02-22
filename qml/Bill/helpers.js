.pragma library

function rounded(number) {
    if(number < 100) {
        return number.toFixed(2)
    } else if(number < 1000) {
        return number.toFixed(1)
    } else {
        return number.toFixed(0)
    }
}

function parseFloatComma(arg1) {
    if(arg1 === "") {
        return 0
    } else {
        return parseFloat(new String(arg1).replace(",","."))
    }
}
