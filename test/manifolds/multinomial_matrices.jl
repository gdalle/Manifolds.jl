include("../header.jl")

@testset "MultinomialMatrices manifold" begin
    M = MultinomialMatrices(3, 2)
    @testset "MultinomialMatrices manifold Basics" begin
        @test ProbabilitySimplex(2)^3 === MultinomialMatrices(3, 3)
        @test ProbabilitySimplex(2)^(3,) === PowerManifold(ProbabilitySimplex(2), 3)
        @test ^(ProbabilitySimplex(2), 2) === MultinomialMatrices(3, 2)
        @test typeof(^(ProbabilitySimplex(2), 2)) == MultinomialMatrices{
            TypeParameter{Tuple{3,2}},
            ProbabilitySimplex{TypeParameter{Tuple{2}},:open},
        }
        @test repr(M) == "MultinomialMatrices(3, 2)"
        @test representation_size(M) == (3, 2)
        @test manifold_dimension(M) == 4
        @test !is_flat(M)
        @test Manifolds.get_iterator(ProbabilitySimplex(3)^4) === Base.OneTo(4)
        p = [2, 0, 0]
        p2 = [p p]
        @test !is_point(M, p)
        @test_throws DomainError is_point(M, p; error=:error)
        @test !is_point(M, p2)
        @test_throws CompositeManifoldError is_point(M, p2; error=:error)
        @test !is_vector(M, p2, 0.0)
        @test_throws CompositeManifoldError{ComponentManifoldError{Int64,DomainError}} is_vector(
            M,
            p2,
            [-1.0, 0.0, 0.0];
            error=:error,
        )
        @test !is_vector(M, p2, [-1.0, 0.0, 0.0])
        @test_throws DomainError is_vector(M, p, [-1.0, 0.0, 0.0]; error=:error)
        @test injectivity_radius(M) ≈ 0
        x = [0.5 0.4 0.1; 0.5 0.4 0.1]'
        @test_throws DomainError is_vector(M, x, [0.0, 0.0, 0.0]; error=:error) # tangent wrong
        y = [0.6 0.3 0.1; 0.4 0.5 0.1]'
        z = [0.3 0.6 0.1; 0.6 0.3 0.1]'
        test_manifold(
            M,
            [x, y, z],
            test_injectivity_radius=false,
            test_vector_spaces=true,
            test_project_tangent=false,
            test_musical_isomorphisms=true,
            test_default_vector_transport=false,
            is_tangent_atol_multiplier=5.0,
            test_inplace=true,
        )
    end
    @testset "field parameter" begin
        M = ProbabilitySimplex(2; parameter=:field)
        @test typeof(^(M, 2)) ==
              MultinomialMatrices{Tuple{Int64,Int64},ProbabilitySimplex{Tuple{Int64},:open}}

        M = MultinomialMatrices(3, 2; parameter=:field)
        @test repr(M) == "MultinomialMatrices(3, 2; parameter=:field)"
    end
end
