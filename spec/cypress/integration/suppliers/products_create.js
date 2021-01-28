describe("Suppliers: Can create products", () => {
  beforeEach(() => {
    cy.app("clean");
  });

  it("creates products", () => {
    cy.appFactories([["create", "supplier", {}]]).then((results) => {
      const record = results[0]
      cy.appFactories([
        ["create", "product", { supplier_id: record.id }]
      ]).then((results) => {
        const record = results[0]
        cy.visit(`/products/${record.id}`);
        cy.shouldHaveHeaderAndFooter();
      });
    });
  });
});
