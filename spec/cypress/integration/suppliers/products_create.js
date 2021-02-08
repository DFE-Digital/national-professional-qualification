describe("Suppliers: Can create products", () => {
  beforeEach(() => {
    cy.app("clean");
  });

  it("creates products", () => {
    cy.appFactories([["create", "supplier", {}]]).then((results) => {
      const supplier = results[0];
      cy.appFactories([
        [
          "create",
          "product",
          { supplier_id: supplier.id, quantity: 100, price: 1000 }
        ]
      ]).then((results) => {
        const product = results[0];
        cy.forceLogin({ redirect_to: `/products/${product.id}` });
        cy.shouldHaveHeaderAndFooter();
        cy.get("#main-content")
          .should(
            "include.text",
            "The total value of this product is £100,000 with 100 course positions being offered."
          )
          .should(
            "include.text",
            "Each course position is being offered at £1,000."
          )
          .should(
            "include.text",
            "There will be 19 guarenteed payments, totalling £40,000."
          );
      });
    });
  });
});
