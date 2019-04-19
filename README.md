#  shopmate

## Architecture
shopmate is built in [Clean Swift](https://clean-swift.com) with a custom design.

I remove `Presenter` in clean swift and connect directly `View Controller` to `Interactor`. This change makes the architecture becomes very flexible to change the requirements.   

## Technique 
Using Auto Layout Programmatically instead of Interface Builder. I use my own library to build this. Check it out [here](https://www.codementor.io/nguyentruongky33/starting-auto-layout-programmatically-r43vwn0po).

UI implementation with `knStaticListController` (detail is [here](https://www.codementor.io/nguyentruongky33/implement-flexible-ui-with-uitableview-slww3uor5)). This skill helps to build UI flexibly and fast.

## Features

1. Login/Register
DONE

2. Products list
- Load list - DONE
- Load more - DONE

3. Product Detail 
- Color Selection - DONE
- Size Selection - DONE
- Image presentation - DONE 
- Get cart count - DONE
- Review - DONE

- Rating - Upcoming 
- Add to wishlist - Upcoming 

**Note** 
- The API should return available colors and sizes, instead of using general options.
- Images should return urls (or a document to get images). I had to contact to Khuong to know how to download images. 

4. Cart
- Get cart items - DONE
- Update items - DONE
- Remove items - DONE

5. Checkout 
- Select card - DONE 
- Add card - DONE
- Select Address - DONE
- Select shipping method - DONE

**Note**
- I use my stripe library instead of calling the API. 

6. Filter - DONE

**Note**
You don't support filter api, so I have to do a trick. Load all products by loading pagination and filter on loaded products. 

7. Search - DONE

**Note**
Your search api sometimes returns empty, while there are some products contain that keyword, for instance `arc`.

6. Menu 
- My Profile - DONE
- Payment method - DONE 
- Logout - DONE
- Address - DONE


## Improvement
- State (loading, empty) - DONE
- Animation when add to cart 
- Wishlist 
- Category 
- Add app icon - DONE

## Working hours 
I can't commit for this project full time. So work few hours everyday. 

- Prepare UI graphics design: 2hours
- Login/Register: 3 hours
- Products list: 2 hours
- Product detail: 4 hours
- Cart: 4 hours
- Payment method: 2 hours
- Menu: 1 hour
- Filter: 2 hours
- Search: 1 hour
- Payment flow: 3 hours
- Address: 1 hour
- Shipping: 3 hours

Total: 28 hours. 

## Contact 
Ky Nguyen 

nguyentruongky33@gmail.com

Skype: nguyentruongky3390


