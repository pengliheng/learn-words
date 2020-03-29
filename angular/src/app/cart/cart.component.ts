import { Component, OnInit } from '@angular/core';
import { CartService } from '../cart.service';
import { ProductType } from '../products';
import { FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit {
  items: ProductType[];
  checkoutForm;
  constructor(
    private cartService: CartService,
    private formBuilder: FormBuilder,
  ) {
    this.checkoutForm = this.formBuilder.group({
      name: '',
      address: '',
    });
  }

  ngOnInit(): void {
    this.items = this.cartService.getItems();
  }

  onSubmit(customerData) {
    console.warn('Your order has been submitted', customerData);
    this.items = this.cartService.clearCart();
    this.checkoutForm.reset();
  }

}
