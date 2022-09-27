import sys
import clingo
from clingo.application import Application, clingo_main

class Propagator():

    called = 0

    def init(self, init):

        
        not_facts_count = 0
        for s_atom in init.symbolic_atoms:
            if init.solver_literal(s_atom.literal) > 1 and s_atom.symbol.arguments[-1].number == Propagator.called:
                not_facts_count += 1

        print(f"positive atoms at step {Propagator.called}: {not_facts_count}")

        for s_atom in init.symbolic_atoms:
            if init.solver_literal(s_atom.literal) > 1 and s_atom.symbol.arguments[-1].number == Propagator.called:
                print(s_atom.symbol, init.solver_literal(s_atom.literal))
        
        Propagator.called += 1

class ClingoApp(Application):
    def __init__(self, name):
        self.program_name = name

        self.current_goal = None

        self.max_step_ground = 0

        self.nodes = {}

    def __on_model(self, m):
        print(m)

    def main(self, ctl, files):
        horizon = 3

        for f in files:
            ctl.load(f)
        if not files:
            ctl.load("-")
        
        ctl.register_propagator(Propagator())

        print(files)
        ctl.ground([("base", [])])
        ctl.solve()
        for i in range(1, horizon+1):
            ctl.ground([("step", [clingo.Number(i)])])
            ctl.solve()
        
        #ctl.ground([("goal", [clingo.Number(horizon)])])
        #ctl.assign_external(clingo.Function("query", [clingo.Number(horizon)]), True)

clingo_main(ClingoApp(sys.argv[0]), sys.argv[1:])