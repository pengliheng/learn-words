/**
 * Created by PanJiaChen on 16/11/18.
 */

/**
 * @param {string} path
 * @returns {Boolean}
 */
import { isAmountValid } from '@/utils/validateAmount'
import { ERROR_CODE_MSG_MAP } from '@/utils/constants'

export function isExternal(path) {
  return /^(https?:|mailto:|tel:)/.test(path)
}

/**
 * @param {string} str
 * @returns {Boolean}
 */
export function validUsername(str) {
  const valid_map = ['admin', 'editor', 'daisong']
  return valid_map.indexOf(str.trim()) >= 0
}

/**
 * @param {string} url
 * @returns {Boolean}
 */
export function validURL(url) {
  const reg = /^(https?|ftp):\/\/([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&%$-]+)*@)*((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}|([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(:[0-9]+)*(\/($|[a-zA-Z0-9.,?'\\+&%$#=~_-]+))*$/
  return reg.test(url)
}

/**
 * @param {string} str
 * @returns {Boolean}
 */
export function validLowerCase(str) {
  const reg = /^[a-z]+$/
  return reg.test(str)
}

/**
 * @param {string} str
 * @returns {Boolean}
 */
export function validUpperCase(str) {
  const reg = /^[A-Z]+$/
  return reg.test(str)
}

/**
 * @param {string} str
 * @returns {Boolean}
 */
export function validAlphabets(str) {
  const reg = /^[A-Za-z]+$/
  return reg.test(str)
}

/**
 * @param {string} email
 * @returns {Boolean}
 */
export function validEmail(email) {
  const reg = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  return reg.test(email)
}

/**
 * @param {string} str
 * @returns {Boolean}
 */
export function isString(str) {
  if (typeof str === 'string' || str instanceof String) {
    return true
  }
  return false
}

/**
 * @param {Array} arg
 * @returns {Boolean}
 */
export function isArray(arg) {
  if (typeof Array.isArray === 'undefined') {
    return Object.prototype.toString.call(arg) === '[object Array]'
  }
  return Array.isArray(arg)
}

/**
 * @param {Array} arg
 * @returns {Boolean}
 */
export function validateBlank(rule, value, callback) {
  if (value === '') {
    callback(new Error('Please avoid empty value'))
  } else if (String(value).trim() === '') {
    callback(new Error('Please avoid pure space'))
  } else {
    callback()
  }
}

export function validAmount(rule, value, callback) {
  const { isValid, errCode } = isAmountValid(value)

  if (isValid) {
    callback()
  } else {
    callback(new Error(`${ERROR_CODE_MSG_MAP[errCode]}`))
  }
}

/**
 * @param {Array} arg
 * @returns {Boolean}
 */
export function validateInteger(rule, value, callback) {
  if (value === '') {
    callback(new Error('Please avoid empty value'))
  } else if (String(value).trim() === '') {
    callback(new Error('Please avoid pure space'))
  } else if (value % 1 !== 0) {
    callback(new Error('Sequence should be long'))
  } else {
    callback()
  }
}

export function sequenceValidator(rule, value, callback) {
  const reg = /^\+?[1-9]\d{0,2}$/
  if (value === '') {
    callback(new Error('Please avoid empty value'))
  } else if (String(value).trim() === '') {
    callback(new Error('Please avoid pure space'))
  } else if (!reg.test(value)) {
    callback(new Error(`Please make sure the "seq" is integer(1-999). Any letter or symbol is not allowed.`))
  } else {
    callback()
  }
}
