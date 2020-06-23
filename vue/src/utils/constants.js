'use strict'

// import RulesStatus from '@/model/RulesStatus'

const CONSTANTS = {
  ERROR_CODE_MSG_MAP: {
    '0': 'Denied, include illegal characters',
    '1': 'Denied, has an illegal format',
    '2': 'Denied, has an illegal format',
    '3': 'Denied, has an illegal format',
    '4': 'Denied, has an illegal format',
    '5': 'Denied, has an illegal format',
    '6': 'Denied, has an illegal format'
  },
  FILE_TYPE: {
    'ADDITIONAL': 'ADDITIONAL',
    'MT700': 'MT700',
    'MT707': 'MT707',
    'MT752': 'MT752',
    'MT710': 'MT710',
    'FPDE': 'FPDE',
    'BE': 'BE',
    'INV': 'INV',
    'BL': 'BL',
    'CPBL': 'CPBL',
    'AWB': 'AWB',
    'MMBL': 'MMBL',
    'PL': 'PL',
    'BC': 'BC',
    'COA': 'COA',
    'CO': 'CO',
    'FC': 'FC',
    'IC': 'IC',
    'NNSW': 'NNSW',
    'SR': 'SR',
    'GP': 'GP',
    'RRIW': 'RRIW',
    'WL': 'WL',
    'UNKNOWN': 'UNKNOWN'
  },
  CASE_STATUS: {
    0: 'Create Case',
    1: 'Assign',
    2: 'Taken',
    3: 'File Split',
    4: 'Auto Check',
    5: 'Running',
    6: 'Human Check',
    7: 'Done'
  },
  CASE_RESULT: {
    '0': ' ',
    '1': 'Pass',
    '-1': 'Failed'
  },
  ACCOUNT_DEPARTMENT: {
    'full stack': 'Full Stack',
    'data science': 'Data Science',
    'marking': 'Marking',
    'hr': 'HR'
  },
  ADD_CASE_DOCUMENT_TYPE: {
    0: 'No file for now',
    1: 'Upload files from local'
  },
  EDIT_CASE_DOCUMENT_TYPE: {
    1: 'Upload files from local'
  },
  LOGICFILE_STATUS: {
    0: 'Unchecked',
    1: 'Processing',
    2: 'Checked'
  },
  HUMAN_VERIFICATION_STATUS: {
    0: 'No',
    1: 'Yes'
  },
  RULE_CHECK_STATUS: {
    0: 'Unchecked',
    1: 'Processing',
    2: 'Checked'
  },
//   LOGICFILE_RULE_CHECK_STATUS: {
//     [RulesStatus.INIT.code]: 'Unchecked',
//     [RulesStatus.CHECKING.code]: 'Checking',
//     [RulesStatus.CHECKING_OCR.code]: 'OCR Checking',
//     [RulesStatus.CHECKING_MRC.code]: 'MRC Checking',
//     [RulesStatus.MRC_DONE.code]: 'MRC Done',
//     [RulesStatus.CHECKING_RULES.code]: 'Rule Checking',
//     [RulesStatus.SUCCESS.code]: 'Completed',
//     [RulesStatus.FAILED.code]: 'Error'
//   },
//   LOGICFILE_RULE_CHECK_STATUS_PROCESS_PERCENT: {
//     [RulesStatus.INIT.code]: 0,
//     [RulesStatus.CHECKING.code]: 0,
//     [RulesStatus.CHECKING_OCR.code]: 20,
//     [RulesStatus.CHECKING_MRC.code]: 60,
//     [RulesStatus.MRC_DONE.code]: 80,
//     [RulesStatus.CHECKING_RULES.code]: 80,
//     [RulesStatus.SUCCESS.code]: 100,
//     [RulesStatus.FAILED.code]: 100
//   },
  RULE_RESULT_STATUS: {
    '1': 'Clean',
    '2': 'Discrepancy',
    '-1': 'Error'
  },
  Lock_STATUS: {
    '1': 'Locked',
    '0': 'Unlocked'
  },
  DISCREPANCY_REASON_LIST: [
    'Some Fields are missing...',
    'Runtime Error happened in running rule expression',
    'Other Reason...'
  ],
  FIELD_DICT_TYPES: [{
    label: 'Bank',
    value: 'bank'
  }, {
    label: 'Airport',
    value: 'airport'
  }, {
    label: 'Seaport',
    value: 'seaport'
  }, {
    label: 'Port',
    value: 'port'
  }, {
    label: 'Length',
    value: 'length'
  }, {
    label: 'Volume',
    value: 'volume'
  }, {
    label: 'Area',
    value: 'area'
  }, {
    label: 'Weight',
    value: 'weight'
  }, {
    label: 'Currency',
    value: 'currency'
  }],
  FIELD_TYPES: [{
    label: 'String',
    value: 'string'
  }, {
    label: 'Int',
    value: 'int'
  }, {
    label: 'Long',
    value: 'long'
  }, {
    label: 'Double',
    value: 'double'
  }, {
    label: 'Float',
    value: 'float'
  }, {
    label: 'Boolean',
    value: 'boolean'
  }, {
    label: 'Date',
    value: 'date'
  }, {
    label: 'Complex',
    value: 'complex'
  }],
  CATEGORIES: {
    'basic': 'Basic',
    'instructional': 'Instructional'
  },
  TASK_STATUS: {
    '0': 'Initial',
    '1': 'In Process',
    '2': 'On Hold',
    '3': 'Done'
  },
  DEFAULT_TAGS: {
    NOTEMPTY: {
      name: 'Not Empty Field',
      value: 'Not Empty Field',
      color: '#19CAAD'
    },
    EMPTY: {
      name: 'Empty Field',
      value: 'Empty Field',
      color: '#F4606C'
    },
    HC: {
      name: 'Human Check Field',
      value: 'Human Check Field',
      color: '#A0EEE1'
    },
    NOTHC: {
      name: 'Not Human Check Field',
      value: 'Not Human Check Field',
      color: '#D1BA74'
    },
    FIRSTBATCH: {
      name: '1st Version Support',
      value: '1',
      color: '#BEEDC7'
    },
    SECONDBATCH: {
      name: '2nd Version Support',
      value: '2',
      color: '#E6CEAC'
    }
  },
  Customized_Tag_Colors: ['#CC560A', '#3A5267', '#BC6EFA', '#D20AD9', '7A0A89', '#FF8C00', '#FFB6C1', '#CC0033', '#FFF000']
}

const {
  ERROR_CODE_MSG_MAP,
  FILE_TYPE,
  CASE_STATUS,
  CASE_RESULT,
  ACCOUNT_DEPARTMENT,
  ADD_CASE_DOCUMENT_TYPE,
  EDIT_CASE_DOCUMENT_TYPE,
  LOGICFILE_STATUS,
  HUMAN_VERIFICATION_STATUS,
  RULE_CHECK_STATUS,
  LOGICFILE_RULE_CHECK_STATUS,
  LOGICFILE_RULE_CHECK_STATUS_PROCESS_PERCENT,
  RULE_RESULT_STATUS,
  Lock_STATUS,
  DISCREPANCY_REASON_LIST,
  FIELD_DICT_TYPES,
  FIELD_TYPES,
  CATEGORIES,
  TASK_STATUS,
  DEFAULT_TAGS,
  Customized_Tag_Colors
} = CONSTANTS

export const REGIONS = ['Asia', 'Europe', 'Africa', 'Americas', 'Antarctica', 'Oceania']

export {
  ERROR_CODE_MSG_MAP,
  FILE_TYPE,
  CASE_STATUS,
  CASE_RESULT,
  ACCOUNT_DEPARTMENT,
  ADD_CASE_DOCUMENT_TYPE,
  EDIT_CASE_DOCUMENT_TYPE,
  LOGICFILE_STATUS,
  HUMAN_VERIFICATION_STATUS,
  RULE_CHECK_STATUS,
  LOGICFILE_RULE_CHECK_STATUS,
  LOGICFILE_RULE_CHECK_STATUS_PROCESS_PERCENT,
  RULE_RESULT_STATUS,
  Lock_STATUS,
  DISCREPANCY_REASON_LIST,
  FIELD_DICT_TYPES,
  FIELD_TYPES,
  CATEGORIES,
  TASK_STATUS,
  DEFAULT_TAGS,
  Customized_Tag_Colors
}

export const CATEGOGIES = {
  COMPLEX: 'complex',
  BASIC: 'basic'
}

export const TYPES = {
  OBJECT: 'object',
  ARRAY: 'array'
}

export const isNecessaryOptions = [{
  label: 'True',
  value: true
}, {
  label: 'False',
  value: false
}]

export const typeOptions = [{
  label: 'String',
  value: 'string'
}, {
  label: 'Number',
  value: 'int'
}, {
  label: 'Float Number',
  value: 'float'
}, {
  label: 'Boolean',
  value: 'boolean'
}, {
  label: 'Date',
  value: 'date'
}]

export const dictTypeOptions = [{
  label: 'Airport',
  value: 'airport'
}, {
  label: 'Seaport',
  value: 'seaport'
}, {
  label: 'Port',
  value: 'port'
}, {
  label: 'Bank',
  value: 'bank'
}]

export const DEFAULT_ARRAY_TEMPLATE_NAME = 'Fields'

export const DEFAULT_OBJECT_TEMPLATE_NAME = 'Goods'

export const ACTIVITY_ACTION_TYPES = {
  ROUTE: 'route',
  API: 'api',
  HEARTBEAT: 'heartbeat'
}

export const PAGES = {
  DC: 'Document Check',
  FILE_MANAGE: 'File Management',
  FILE_SPLIT: 'File Split',
  PROCESSED_FILES: 'Processed Files',
  RULE_LIST: 'Rule List',
  RULE_CHECK: 'Rule Check'
}

export const ACTIVITIES = {
  HUMAN_CHECK: 'human check',
  FILE_SPLIT: 'file split',
  OTHERS: 'others'
}

export const FULLPATHS = [{
  path: '/case/check',
  page: PAGES.DC,
  activity: ACTIVITIES.HUMAN_CHECK
}, {
  path: '/case/file/management',
  page: PAGES.FILE_MANAGE,
  activity: ACTIVITIES.FILE_SPLIT
}, {
  path: '/case/file/split',
  page: PAGES.FILE_SPLIT,
  activity: ACTIVITIES.FILE_SPLIT
}, {
  path: '/case/file/fileProcessedList',
  page: PAGES.PROCESSED_FILES,
  activity: ACTIVITIES.OTHERS
}, {
  path: '/case/ruleList',
  page: PAGES.RULE_LIST,
  activity: ACTIVITIES.HUMAN_CHECK
}, {
  path: '/case/rule/ruleCheck',
  page: PAGES.RULE_CHECK,
  activity: ACTIVITIES.HUMAN_CHECK
}]

