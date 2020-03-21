import * as React from 'react'
const { useState } = React
import {
  Avatar,
  Button,
  CssBaseline,
  TextField,
  FormControlLabel,
  Checkbox,
  Link,
  Grid,
  Box,
  Typography,
  Container,
} from '@material-ui/core'
import LockOutlinedIcon from '@material-ui/icons/LockOutlined'
import { makeStyles } from '@material-ui/core/styles'
import Snackbar, { SnackbarOrigin } from '@material-ui/core/Snackbar'
import MuiAlert, { AlertProps,Color } from '@material-ui/lab/Alert'
import Api from "../Api"

function Copyright() {
  return (
    <Typography variant="body2" color="textSecondary" align="center">
      {'Copyright © '}
      <Link color="inherit" href="https://material-ui.com/">
        Your Website
      </Link>{' '}
      {new Date().getFullYear()}
      {'.'}
    </Typography>
  )
}
interface MsgState extends SnackbarOrigin {
  open: boolean
  message: string
  status: Color | undefined
}
interface InputState extends API.SignUp.Request {
  confirmPassword: string
}
function Alert(props: AlertProps) {
  return <MuiAlert elevation={6} variant="filled" {...props} />
}

const useStyles = makeStyles(theme => ({
  paper: {
    marginTop: theme.spacing(8),
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.secondary.main,
  },
  form: {
    width: '100%', // Fix IE 11 issue.
    marginTop: theme.spacing(1),
  },
  submit: {
    margin: theme.spacing(3, 0, 2),
  },
}))
export default function SignIn() {
  const classes = useStyles()
  // open message status
  const [msgState, setMsgState] = useState<MsgState>({
    open: false,
    message: 'bla bla',
    vertical: 'top',
    horizontal: 'center',
    status: 'success'
  })
  const { vertical, horizontal, open, message, status } = msgState
  // input message
  const [inputState, setInputState] = useState<InputState>({
    username: '',
    password: '',
    confirmPassword: ''
  })
  const { username,password,confirmPassword } = inputState
  async function handleSubmit(event: React.SyntheticEvent) {
    event.preventDefault()
    const res = await Api.SignIn({
      username: '',
      password: ''
    })
    if (res.data.errorCode === 1) {
      setMsgState({ ...msgState, message: res.data.message, open: true })
    }
  }
  const handleClose = () => {
    setMsgState({ ...msgState, open: false })
  }
  return (
    <Container component="main" maxWidth="xs">
      <Snackbar
        open={open}
        onClose={handleClose}
        anchorOrigin={{ vertical, horizontal }}
        autoHideDuration={2000}
      >
        <Alert severity={status}>
          {message}
        </Alert>
      </Snackbar>
      <CssBaseline />
      <div className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LockOutlinedIcon />
        </Avatar>
        <Typography component="h1" variant="h5">
          Sign up
        </Typography>
        <form className={classes.form} noValidate onSubmit={handleSubmit}>
          <TextField value={username} autoComplete="off" variant="outlined" margin="normal" required fullWidth id="userName" label="User Name" name="userName" autoFocus />
          <TextField value={password} autoComplete="off" variant="outlined" margin="normal" required fullWidth name="password" label="Password" type="password" id="password" />
          <TextField value={confirmPassword} autoComplete="off" variant="outlined" margin="normal" required fullWidth name="confirmPassword" label="Confirm Password" type="password" id="confirmPassword" />
          <FormControlLabel control={<Checkbox value="remember" color="primary" />} label="Remember me" />
          <Button type="submit" fullWidth variant="contained" color="primary" className={classes.submit} >
            Sign In
          </Button>
          <Grid container>
            <Grid item xs></Grid>
            <Grid item>
              <Link href="/Sign In" variant="body2">
                {"Have an account? Sign In"}
              </Link>
            </Grid>
          </Grid>
        </form>
      </div>
      <Box mt={8}>
        <Copyright />
      </Box>
    </Container>
  )
}