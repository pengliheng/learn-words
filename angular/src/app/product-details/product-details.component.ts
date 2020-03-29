import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { products, ProductType } from '../products';
import { CartService } from '../cart.service';

@Component({
  selector: 'app-product-details',
  templateUrl: './product-details.component.html',
  styleUrls: ['./product-details.component.scss']
})
export class ProductDetailsComponent implements OnInit {
  product: ProductType;
  constructor(
    private route: ActivatedRoute,
    private cartService: CartService,
  ) { }
  addToCart(product: ProductType) {
    this.cartService.addToCart(product);
    console.log('Your product has been added to the cart!');
  }
  ngOnInit(): void {
    this.route.paramMap.subscribe(params => {
      this.product = products[params.get('productId')];
    });
  }

}
