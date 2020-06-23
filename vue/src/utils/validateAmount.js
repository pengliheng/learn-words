'use strict'

var DEMICAL_SEPARATOR = '.'
var THOUSAND_SEPARATOR = ','
// 千分位判断， 通过,进行split，只有第一个part是1-3位，其他的均为3位
function isThousandFormat(str) {
  var parts = str.split(THOUSAND_SEPARATOR)
  var first = parts[0]
  parts.shift()
  return first.length >= 1 && first.length <= 3 && parts.every(function(part) { return part.length === 3 })
}
// 左侧要么为空，要么为整数，要么为千分位
function isLeftPartValid(str) {
  return str === '' || !isNaN(Number(str)) || isThousandFormat(str)
}
// 右侧的数字要求，不超过2位小数
function isRightPartValid(str) {
  return str.indexOf(THOUSAND_SEPARATOR) === -1 && str.length < 3
}
/**
 * 对amount str进行验证，验证规则如下：
 * 1. 只能包含数字和.和,
 * 2. 如果有俩个以上的小数点，则直接返回false
 * 3. 如果有一个小数点，则：
 *   3-1. 如果小数点左侧和右侧均为空，则直接返回false
 *   3-2. 如果小数点左侧满足（千分位/正整数/空）且小数点右侧满足全部为数字，且长度不超过2位，则正确，否则错误
 * 4. 如果没有小数点， 则：
 *   4-1. 如果没有逗号，则直接为true（因为全部为数字）
 *   4-2. 如果有逗号，通过逗号将str进行分割，：
 *     4-2-1. 如果最后一个part的长度大于3，则直接返回false
 *     4-2-2. 如果最后一个part的长度为3，则说明str仍然是一个千分位整数，需要str满足千分位
 *     4-2-3. 如果最后一个part的长度小于3，则说明最后一个逗号是用来做小数点用的，则只需要除了最后一个part外的其他parts组合的字符串满足千分位即可
 * @param str
 */
var ValidateResult = /** @class */ (function() {
  function ValidateResult(obj) {
    this.isValid = obj.isValid
    this.errCode = obj.errCode
  }
  return ValidateResult
}())
function isAmountValid(str) {
  str = str.trim()
  str = str.replace(/，/g, ',')

  if (!/^[0-9.,]+$/.test(str)) {
    return new ValidateResult({
      isValid: false,
      errCode: 0
    })
  }
  var parts = str.split(DEMICAL_SEPARATOR)
  var demicalSeparators = parts.length - 1
  if (demicalSeparators > 1) {
    return new ValidateResult({
      isValid: false,
      errCode: 1
    })
  } else if (demicalSeparators === 1) {
    if (!parts[0] && !parts[1]) {
      return new ValidateResult({
        isValid: false,
        errCode: 2
      })
    } else if (!isLeftPartValid(parts[0])) {
      return new ValidateResult({
        isValid: false,
        errCode: 5
      })
    } else if (!isRightPartValid(parts[1])) {
      return new ValidateResult({
        isValid: false,
        errCode: 6
      })
    } else {
      return new ValidateResult({
        isValid: true
      })
    }
  } else {
    var thousandParts = str.split(THOUSAND_SEPARATOR)
    var thousandSeparators = thousandParts.length - 1
    if (thousandSeparators === 0) {
      return new ValidateResult({
        isValid: true
      })
    } else {
      var lastPart = thousandParts[thousandParts.length - 1]
      if (lastPart.length > 3) {
        return new ValidateResult({
          isValid: false,
          errCode: 3
        })
      } else if (lastPart.length === 3) {
        return isThousandFormat(str) ? new ValidateResult({
          isValid: true
        }) : new ValidateResult({
          isValid: false,
          errCode: 4
        })
      } else {
        thousandParts.pop()
        return isLeftPartValid(thousandParts.join(THOUSAND_SEPARATOR)) ? new ValidateResult({
          isValid: true
        }) : new ValidateResult({
          isValid: false,
          errCode: 5
        })
      }
    }
  }
}
/**
 * 将合法的str，转化为number, 步骤如下：
 * 1，如果有小数点，则直接去除逗号，然后parseFloat
 * 2. 如果没有小数点，则按照是否有逗号区分，
 *     2-1. 没有逗号，直接parseFloat
 *     2-2. 有逗号的情况下，取最后一个逗号后面的part，如果是三位数字，则直接去除str的全部逗号然后parseFloat
 *     2-3. 否则，将最后一个逗号当小数点用，同时去除全部的逗号，然后parseFloat
 * @param str
 */
function parseAmount(str) {
  str = str.replace(/，/g, ',')

  if (!isAmountValid(str).isValid) { return null }
  var parts = str.split(DEMICAL_SEPARATOR)
  var demicalSeparators = parts.length - 1
  if (demicalSeparators === 1) {
    return parseFloat(str.replace(/,/g, ''))
  } else {
    var thousandParts = str.split(THOUSAND_SEPARATOR)
    var thousandSeparators = thousandParts.length - 1
    if (thousandSeparators === 0) {
      return parseFloat(str)
    } else {
      var lastPart = thousandParts[thousandParts.length - 1]
      if (lastPart.length === 3) {
        return parseFloat(str.replace(/,/g, ''))
      } else {
        thousandParts.pop()
        var left = thousandParts.join('') || '0'
        var tmp = left + '.' + lastPart
        return parseFloat(tmp)
      }
    }
  }
}

export {
  parseAmount,
  isAmountValid
}
