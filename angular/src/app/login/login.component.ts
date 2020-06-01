import { Component, OnInit, NgModule } from '@angular/core';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  constructor(
  ) { }

  ngOnInit(): void {
  }

  handleLogin(): void {
    console.log('now handle login');
  }
  handleRegister(): void {
    console.log('now handle register');
  }
}
