describe("Products: Statements", () => {
  beforeEach(() => {
    cy.app("clean");
  });

  it("creates statements when approved by admin", () => {
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
        cy.contains("Approve Product").click();
        cy.get(".govuk-table__body > :nth-child(1)")
          .should("include.text", "Fixed Payment 1 - My Product")
          .should("include.text", "£2,105.26");
        cy.get(".govuk-table__body > :last-child")
          .should("include.text", "Fixed Payment Final - My Product")
          .should("include.text", "£2,105.32");
      });
    });
  });
});
